# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_swipe, mutation: Mutations::CreateSwipe
    field :upload_photo, mutation: Mutations::UploadPhoto

    # Mutations for user authentication
    field :login_user, mutation: Mutations::LoginUser
    field :register_user, mutation: Mutations::RegisterUser
  end
end
