class Match < ApplicationRecord
  # associations
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  # associations for messages
  has_many :messages, dependent: :destroy

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

  public

  # retrieve the latest message of a match
  def latest_message
    messages.order(created_at: :desc).first
  end

  # retrieve the counts for each unread message of a match
  def unread_count_for(user_id)
    messages.where(receiver_id: user_id, read: false).count
  end
end