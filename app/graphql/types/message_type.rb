module Types
  class MessageType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :read, Boolean, null: false
    field :sender, Types::UserType, null: false
    field :receiver, Types::UserType, null: false
    field :match, Types::MatchType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end