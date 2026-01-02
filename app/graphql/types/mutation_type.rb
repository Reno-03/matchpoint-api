# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Mutations for user authentication
    field :login_user, mutation: Mutations::LoginUser
    field :register_user, mutation: Mutations::RegisterUser
  end
end
