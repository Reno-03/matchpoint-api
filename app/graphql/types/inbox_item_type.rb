module Types
  class InboxItemType < Types::BaseObject
    field :match, Types::MatchType, null: false
    field :other_user, Types::UserType, null: false
    field :latest_message, Types::MessageType, null: true
    field :unread_count, Integer, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end