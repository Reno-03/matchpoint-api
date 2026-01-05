# frozen_string_literal: true

module Mutations
  class UpdateUser < BaseMutation
    argument :user_id, ID, required: true
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :email, String, required: false
    argument :bio, String, required: false
    argument :city, String, required: false
    argument :role, String, required: false
    argument :mobile, String, required: false        
    argument :school, String, required: false        
    argument :sexual_orientation, String, required: false 

    field :user, Types::AdminUserType, null: true
    field :errors, [String], null: false

    def resolve(user_id:, **args)
      admin = context[:current_user]

      # check authentication and authorization
      return { user: nil, errors: ['Not authenticated'] } unless admin
      return { user: nil, errors: ['Not authorized'] } unless admin.role == 'admin'

      user = User.find_by(id: user_id)
      return { user: nil, errors: ['User not found'] } unless user

      # optionally sanitize mobile input
      args[:mobile] = args[:mobile].gsub(/\D/, '') if args[:mobile]

      if user.update(args.compact)
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end