# frozen_string_literal: true

module Mutations
  class UploadPhoto < BaseMutation
    argument :image, String, required: true  # Base64 encoded image
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

      # Decode base64 and attach to Cloudinary
      begin
        # Remove data:image/jpeg;base64, prefix if present
        image_data = image.split(',').last
        decoded = Base64.decode64(image_data)
        
        photo.image.attach(
          io: StringIO.new(decoded),
          filename: "photo_#{Time.now.to_i}.jpg",
          content_type: 'image/jpeg'
        )

        if photo.save
          { photo: photo, errors: [] }
        else
          { photo: nil, errors: photo.errors.full_messages }
        end
      rescue => e
        { photo: nil, errors: [e.message] }
      end
    end
  end
end