# frozen_string_literal: true

module Mutations
  class RegisterUser < BaseMutation
    # exposes the argument details required to register a user
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :birthdate, GraphQL::Types::ISO8601Date, required: true
    argument :gender, String, required: true
    argument :gender_interest, String, required: true
    argument :country, String, required: true
    argument :city, String, required: true
    argument :mobile, String, required: true
    argument :sexual_orientation, String, required: true
    argument :school, String, required: false
    argument :bio, String, required: false

    # exposes the return fields after a user is registered
    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    # a method that registers a user (if it is valid) and returns the user object, JWT token, and any errors
    def resolve(**args)
      user = User.new(args)

      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: user.errors.full_messages }
      end
    end
  end
end
