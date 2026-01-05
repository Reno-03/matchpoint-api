# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    # Fields of the User type
    field :id, ID, null: false
    field :first_name, String
    field :last_name, String
    field :mobile, String 
    field :school, String
    field :sexual_orientation, String
    field :email, String
    field :role, String
    field :birthdate, GraphQL::Types::ISO8601Date
    field :gender, String
    field :gender_interest, String
    field :country, String
    field :city, String
    field :bio, String

    # Associated photos
    field :photos, [Types::PhotoType], null: true
    field :primary_photo_url, String, null: true

    # a method to get the primary photo URL
    def primary_photo_url
      photo = object.primary_photo
      return unless photo&.image&.attached?
      Rails.application.routes.url_helpers.url_for(photo.image)
    end
  end
end
