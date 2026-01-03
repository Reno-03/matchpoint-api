module Types
  class PhotoType < Types::BaseObject
    # Fields for Photo type
    field :id, ID, null: false
    field :url, String, null: false
    field :position, Integer, null: false
    field :is_primary, Boolean, null: false
    
    # a method to get the URL of the photo
    def url
      return unless object.image.attached?
      Rails.application.routes.url_helpers.url_for(object.image)
    end
  end
end