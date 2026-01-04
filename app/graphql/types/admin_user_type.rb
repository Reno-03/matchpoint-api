module Types
  class AdminUserType < Types::UserType
    field :password_digest, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :matches_count, Integer, null: false
    field :swipes_made_count, Integer, null: false
    field :swipes_received_count, Integer, null: false
    field :messages_sent_count, Integer, null: false

    def matches_count
      object.all_matches.count
    end

    def swipes_made_count
      object.swipes_made.count
    end

    def swipes_received_count
      object.swipes_received.count
    end

    def messages_sent_count
      object.sent_messages.count
    end
  end
end