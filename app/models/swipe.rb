class Swipe < ApplicationRecord
  # possible actions for a swipe
  ACTIONS = %w[like dislike]

  # associations
  belongs_to :swiper, class_name: 'User'
  belongs_to :swiped, class_name: 'User'
  
  # validations
  validates :action, inclusion: { in: ACTIONS }
  validates :swiper_id, uniqueness: { scope: :swiped_id, message: 'already swiped on this user' }
  validate :cannot_swipe_self

  # after creating a swipe, check for mutual likes to create a match
  after_create :check_for_match, if: :like?

  # method to check if the swipe action is a 'like'
  def like?
    action == 'like'
  end

  private

  # a validation to prevent users from swiping on themselves
  def cannot_swipe_self
    errors.add(:base, 'Cannot swipe on yourself') if swiper_id == swiped_id
  end

  # method to check for mutual likes and create a match if found
  def check_for_match
    # Check if the swiped user also liked back
    mutual_swipe = Swipe.find_by(
      swiper_id: swiped_id,
      swiped_id: swiper_id,
      action: 'like'
    )

    # If mutual like exists, create a match
    if mutual_swipe
      # calls create match method in Match model
      create_match
    end
  end

  # method to create a match between two users
  def create_match
    # Prevent duplicate matches
    return if Match.exists?(user1_id: [swiper_id, swiped_id], user2_id: [swiper_id, swiped_id])

    Match.create!(
      user1_id: [swiper_id, swiped_id].min,
      user2_id: [swiper_id, swiped_id].max
    )
  end
end