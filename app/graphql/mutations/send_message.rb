# frozen_string_literal: true

module Mutations
  class SendMessage < BaseMutation
    argument :match_id, ID, required: true
    argument :receiver_id, ID, required: true
    argument :content, String, required: true

    field :message, Types::MessageType, null: true
    field :errors, [String], null: false

    def resolve(match_id:, receiver_id:, content:)
      # if user doesnt exist, return an error
      user = context[:current_user]
      return { message: nil, errors: ['Not authenticated'] } unless user

      # if match doesnt exist, return an error
      match = Match.find_by(id: match_id)
      return { message: nil, errors: ['Match not found'] } unless match

      # Verify user is part of this match
      unless [match.user1_id, match.user2_id].include?(user.id)
        return { message: nil, errors: ['You are not part of this match'] }
      end

      # Verify receiver is the other person in the match
      unless [match.user1_id, match.user2_id].include?(receiver_id.to_i)
        return { message: nil, errors: ['Receiver is not part of this match'] }
      end

      # if all validated, send message and save to database
      message = Message.new(
        sender_id: user.id,
        receiver_id: receiver_id,
        match_id: match_id,
        content: content
      )

      if message.save
        { message: message, errors: [] }
      else
        { message: nil, errors: message.errors.full_messages }
      end
    end
  end
end