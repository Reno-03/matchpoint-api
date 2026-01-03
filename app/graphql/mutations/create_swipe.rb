# frozen_string_literal: true

module Mutations
  class CreateSwipe < BaseMutation
    argument :swiped_id, ID, required: true
    argument :action, String, required: true

    field :swipe, Types::SwipeType, null: true
    field :matched, Boolean, null: false
    field :match, Types::MatchType, null: true
    field :errors, [String], null: false

    def resolve(swiped_id:, action:)
      user = context[:current_user]
      return { swipe: nil, matched: false, match: nil, errors: ['Not authenticated'] } unless user

      swipe = user.swipes_made.new(
        swiped_id: swiped_id,
        action: action
      )

      if swipe.save
        # Check if match was created
        if swipe.like?
          match = Match.find_by(
            user1_id: [user.id, swiped_id.to_i].min,
            user2_id: [user.id, swiped_id.to_i].max
          )
          
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
