class Match < ApplicationRecord
  # associations
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  # validations
  validates :user1_id, uniqueness: { scope: :user2_id }
  validate :users_must_differ

  # method to get the other user in the match
  # why? Because a match involves two users, and given one user's ID,
  # this method returns the other user in the match.
  def other_user(current_user_id)
    user1_id == current_user_id ? user2 : user1
  end

  private

  # validation to ensure the two users in a match are different
  def users_must_differ
    errors.add(:base, 'Users must be different') if user1_id == user2_id
  end
end