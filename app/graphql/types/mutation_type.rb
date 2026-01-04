# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :mark_as_read, mutation: Mutations::MarkAsRead
    field :send_message, mutation: Mutations::SendMessage
    # Mutations for swiping app
    field :create_swipe, mutation: Mutations::CreateSwipe
    field :upload_photo, mutation: Mutations::UploadPhoto

    # Mutations for user authentication
    field :login_user, mutation: Mutations::LoginUser
    field :register_user, mutation: Mutations::RegisterUser
  end
end
