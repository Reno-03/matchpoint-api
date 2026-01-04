# frozen_string_literal: true

module Mutations
  class MarkAsRead < BaseMutation
    argument :message_id, ID, required: true

    field :message, Types::MessageType, null: true
    field :errors, [String], null: false

    def resolve(message_id:)
      # if user doesnt exist, return an error
      user = context[:current_user]
      return { message: nil, errors: ['Not authenticated'] } unless user

      # if message doesnt exist, return an error
      message = Message.find_by(id: message_id)
      return { message: nil, errors: ['Message not found'] } unless message

      # Only receiver can mark as read
      unless message.receiver_id == user.id
        return { message: nil, errors: ['Not authorized'] }
      end

      # if validated, mark the message as read
      if message.update(read: true)
        { message: message, errors: [] }
      else
        { message: nil, errors: message.errors.full_messages }
      end
    end
  end
end
