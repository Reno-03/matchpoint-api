# frozen_string_literal: true

module Mutations
  class CreateSwipe < BaseMutation
    # arguments for creating a swipe, including swiped user ID and action type (like/dislike)
    argument :swiped_id, ID, required: true
    argument :action, String, required: true

    # return fields after creating a swipe attempt, including whether a match was made
    field :swipe, Types::SwipeType, null: true
    field :matched, Boolean, null: false
    field :match, Types::MatchType, null: true
    field :errors, [String], null: false

    # resolve method to handle swipe creation and match checking
    def resolve(swiped_id:, action:)
      user = context[:current_user]

      # exit early if user is not authenticated
      return { swipe: nil, matched: false, match: nil, errors: ['Not authenticated'] } unless user

      # create the swipe record
      swipe = user.swipes_made.new(
        swiped_id: swiped_id,
        action: action
      )

      # save the swipe and check for match
      if swipe.save
        # Check if match was created
        if swipe.like?
          # look for existing match
          # the match would have been created in the Swipe model's after_create callback
          match = Match.find_by(
            user1_id: [user.id, swiped_id.to_i].min,
            user2_id: [user.id, swiped_id.to_i].max
          )
          
          # return match info if found
          if match
            return { swipe: swipe, matched: true, match: match, errors: [] }
          end
        end

        { swipe: swipe, matched: false, match: nil, errors: [] }
      else
        { swipe: nil, matched: false, match: nil, errors: swipe.errors.full_messages }
      end
    end
  end
end
