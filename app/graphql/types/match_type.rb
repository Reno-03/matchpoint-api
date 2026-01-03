module Types
  class MatchType < Types::BaseObject
    # Fields for Match type
    field :id, ID, null: false
    field :user1, Types::UserType, null: false
    field :user2, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end