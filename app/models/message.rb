class Message < ApplicationRecord
  # associations
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :match

  # validations for message content and match
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  validate :sender_and_receiver_must_be_matched

  # variables for unread and for_conversation
  scope :unread, -> { where(read: false) }
  scope :for_conversation, ->(match_id) { where(match_id: match_id).order(created_at: :asc) }

  # changes of timestamp after creating a message
  after_create :update_match_timestamp

  private

  # validation for sender and receiver match
  def sender_and_receiver_must_be_matched
    return unless match

    unless [match.user1_id, match.user2_id].sort == [sender_id, receiver_id].sort
      errors.add(:base, 'Sender and receiver must be part of the match')
    end
  end

  # method for updating timestamp
  def update_match_timestamp
    match.touch
  end
end