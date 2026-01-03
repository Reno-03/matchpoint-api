# frozen_string_literal: true

module Mutations
  class UploadPhoto < BaseMutation
    argument :image, ApolloUploadServer::Upload, required: true
    argument :position, Integer, required: false
    argument :is_primary, Boolean, required: false

    field :photo, Types::PhotoType, null: true
    field :errors, [String], null: false

    def resolve(image:, position: nil, is_primary: false)
      user = context[:current_user]
      return { photo: nil, errors: ['Not authenticated'] } unless user

      if user.photos.count >= 5
        return { photo: nil, errors: ['Maximum 5 photos allowed'] }
      end

      position ||= user.photos.count

      photo = user.photos.new(
        position: position,
        is_primary: is_primary || user.photos.empty?
      )

      photo.image.attach(image)

      if photo.save
        { photo: photo, errors: [] }
      else
        { photo: nil, errors: photo.errors.full_messages }
      end
    end
  end
end