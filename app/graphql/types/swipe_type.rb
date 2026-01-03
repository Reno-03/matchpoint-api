module Types
  class SwipeType < Types::BaseObject
    # Fields for Swipe type
    field :id, ID, null: false
    field :action, String, null: false
    field :swiper, Types::UserType, null: false
    field :swiped, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end