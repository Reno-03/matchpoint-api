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
  end
end
