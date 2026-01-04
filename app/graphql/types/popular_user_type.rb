module Types
  class PopularUserType < Types::BaseObject
    field :user, Types::UserType, null: false
    field :likes_received, Integer, null: false
    field :matches_count, Integer, null: false
  end
end