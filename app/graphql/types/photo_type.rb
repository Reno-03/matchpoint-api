module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :url, String, null: false
    field :position, Integer, null: false
    field :is_primary, Boolean, null: false

    def url
      return unless object.image.attached?
      Rails.application.routes.url_helpers.url_for(object.image)
    end
  end
end