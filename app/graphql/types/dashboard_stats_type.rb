module Types
  class DashboardStatsType < Types::BaseObject
    field :total_users, Integer, null: false
    field :total_matches, Integer, null: false
    field :total_swipes, Integer, null: false
    field :total_messages, Integer, null: false
    field :popular_users, [Types::PopularUserType], null: false
  end
end