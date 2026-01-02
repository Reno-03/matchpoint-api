# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    # Fields of the User type
    field :id, ID, null: false
    field :first_name, String
    field :last_name, String
    field :email, String
    field :role, String
    field :birthdate, GraphQL::Types::ISO8601Date
    field :gender, String
    field :gender_interest, String
    field :country, String
    field :city, String
    field :bio, String
  end
end
