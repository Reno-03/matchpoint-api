class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :user_photo_limit
  validate :image_presence

  after_destroy :reassign_primary_if_needed

  scope :ordered, -> { order(position: :asc) }

  private

  def user_photo_limit
    return unless user
    if user.photos.count >= 5 && !persisted?
      errors.add(:base, 'Maximum 5 photos allowed')
    end
  end

  def image_presence
    errors.add(:image, 'must be attached') unless image.attached?
  end

  def reassign_primary_if_needed
    return unless is_primary && user
    next_photo = user.photos.ordered.first
    next_photo&.update(is_primary: true)
  end
end