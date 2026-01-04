# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # GRAPHQL QUERIES FOR SWIPING APP
    
    # Get swipe deck query
    # Logic for swipe deck, filtering out already swiped users and matching preferences (gender)
    field :swipe_deck, [Types::UserType], null: false do
      description "Get users for swiping based on preferences"
      argument :limit, Integer, required: false, default_value: 20
    end
    def swipe_deck(limit:)
      user = context[:current_user]
      return [] unless user

      # Users already swiped on
      swiped_ids = user.swipes_made.pluck(:swiped_id)

      # Filter by gender interest
      query = User.where.not(id: [user.id] + swiped_ids)
      
      case user.gender_interest
      when 'Male'
        query = query.where(gender: 'Male')
      when 'Female'
        query = query.where(gender: 'Female')
      when 'Both'
        # No additional filter
      end

      # Also check if they match MY criteria
      query = query.where("gender_interest = ? OR gender_interest = ?", user.gender, 'Both')

      query.limit(limit).order("RANDOM()")
    end


    # current user query
    field :current_user, Types::UserType, null: true
    def current_user
      context[:current_user]
    end

    # Query my matches, for current user
    field :my_matches, [Types::MatchType], null: false
    def my_matches
      user = context[:current_user]
      return [] unless user
      user.all_matches
    end

    # Query for retrieving the inbox of all matches and latest messages for a User
    field :my_inbox, [Types::InboxItemType], null: false do
      description "Get inbox with all matches and latest messages"
    end
    def my_inbox
      user = context[:current_user]
      return [] unless user

      user.all_matches.order(updated_at: :desc).map do |match|
        other_user = match.other_user(user.id)
        latest_message = match.latest_message
        unread_count = match.unread_count_for(user.id)

        {
          match: match,
          other_user: other_user,
          latest_message: latest_message,
          unread_count: unread_count,
          updated_at: match.updated_at
        }
      end
    end

    # Query for getting all messages by a specific match
    field :conversation_messages, [Types::MessageType], null: false do
      description "Get all messages in a conversation"
      argument :match_id, ID, required: true
    end
    def conversation_messages(match_id:)
      user = context[:current_user]
      return [] unless user

      match = Match.find_by(id: match_id)
      return [] unless match

      # Verify user is part of this match
      unless [match.user1_id, match.user2_id].include?(user.id)
        return []
      end

      match.messages.order(created_at: :asc)
    end

    # ADMIN-RELATED QUERIES
    # checks first if user is an admin

    # Query to retrieve all users
    field :all_users, [Types::AdminUserType], null: false do
      description "Admin only: Get all users"
      argument :limit, Integer, required: false, default_value: 50
      argument :offset, Integer, required: false, default_value: 0
    end
    def all_users(limit:, offset:)
      user = context[:current_user]
      return [] unless user&.role == 'admin'

      User.order(created_at: :desc).limit(limit).offset(offset)
    end

    # Query to retrieve a specific user info based on user_id
    field :user_details, Types::AdminUserType, null: true do
      description "Admin only: Get detailed user info"
      argument :user_id, ID, required: true
    end
    def user_details(user_id:)
      user = context[:current_user]
      return nil unless user&.role == 'admin'

      User.find_by(id: user_id)
    end

    # Query to retrieve the matches for a user 
    field :user_matches, [Types::MatchType], null: false do
      description "Admin only: Get all matches for a user"
      argument :user_id, ID, required: true
    end
    def user_matches(user_id:)
      admin = context[:current_user]
      return [] unless admin&.role == 'admin'

      target_user = User.find_by(id: user_id)
      return [] unless target_user

      target_user.all_matches
    end

    # Query to retrieve all matches
    field :all_matches, [Types::MatchType], null: false do
      description "Admin only: Get all matches in the system"
      argument :limit, Integer, required: false, default_value: 50
    end
    def all_matches(limit:)
      user = context[:current_user]
      return [] unless user&.role == 'admin'

      Match.order(created_at: :desc).limit(limit)
    end

    # Query to retrieve dashboard statistics
    field :dashboard_stats, Types::DashboardStatsType, null: true do
      description "Admin only: Get dashboard statistics"
      argument :popular_limit, Integer, required: false, default_value: 10
    end
    def dashboard_stats(popular_limit:)
      admin = context[:current_user]
      return nil unless admin&.role == 'admin'

      # Get popular users (most likes received)
      popular_users = User
        .joins(:swipes_received)
        .where(swipes: { action: 'like' })
        .select('users.*, COUNT(swipes.id) as likes_count')
        .group('users.id')
        .order('likes_count DESC')
        .limit(popular_limit)
        .map do |user|
          {
            user: user,
            likes_received: user.likes_count.to_i,
            matches_count: user.all_matches.count
          }
        end

      {
        total_users: User.count,
        total_matches: Match.count,
        total_swipes: Swipe.count,
        total_messages: Message.count,
        popular_users: popular_users
      }
    end
  end
end
