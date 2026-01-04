# frozen_string_literal: true

module Mutations
  class DeleteUser < BaseMutation
    argument :user_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(user_id:)
      admin = context[:current_user]

      # if user is not authenticated or an admin, return an error
      return { success: false, errors: ['Not authenticated'] } unless admin
      return { success: false, errors: ['Not authorized'] } unless admin.role == 'admin'

      user = User.find_by(id: user_id)
      
      # if search user not found, return an error
      return { success: false, errors: ['User not found'] } unless user

      # Prevent admin from deleting themselves
      if user.id == admin.id
        return { success: false, errors: ['Cannot delete yourself'] }
      end

      # if all validated, delete the user
      if user.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: user.errors.full_messages }
      end
    end
  end
end