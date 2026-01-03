# frozen_string_literal: true

module Mutations
  class LoginUser < BaseMutation
    # arguments used for user login
    argument :email, String, required: true
    argument :password, String, required: true

    # return fields after login attempt
    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    # resolve method to handle user login authentication
    def resolve(email:, password:)
      user = User.find_by(email: email)

      if user&.authenticate(password)
        token = JsonWebToken.encode(user_id: user.id)
        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: ['Invalid credentials'] }
      end
    end
  end
end
