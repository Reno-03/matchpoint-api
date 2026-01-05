class User < ApplicationRecord
  # used for password hashing and authentication  
  has_secure_password

  # associations
  has_many :photos, dependent: :destroy
  has_many :swipes_made, class_name: 'Swipe', foreign_key: 'swiper_id', dependent: :destroy
  has_many :swipes_received, class_name: 'Swipe', foreign_key: 'swiped_id', dependent: :destroy

  # roles for user accounts
  ROLES = %w[user admin]

  validates :first_name, :last_name, :email, :birthdate,
            :gender, :gender_interest, :country, :city, presence: true

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES }
  
  # custom validation to ensure user is at least 18 years old
  validate :must_be_18_or_older
  
  # before creating a user, set default role to 'user' if not provided
  before_validation :set_default_role

  # phone validation
  validate :mobile_number_valid
  validates :mobile, presence: true
  
  # validates :photos, length: { minimum: 1, maximum: 5, message: 'must have 1-5 photos' }

  # MATCH ASSOCIATIONS
  # for each user, define associations to matches where they are user1 or user2 in the Match model
  has_many :matches_as_user1, class_name: 'Match', foreign_key: 'user1_id', dependent: :destroy
  has_many :matches_as_user2, class_name: 'Match', foreign_key: 'user2_id', dependent: :destroy

  # MESSAGE ASSOSCIATIONS
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy


  # this function calculates the age of the user based on birthdate
  def age
    return unless birthdate
    today = Date.today
    age = today.year - birthdate.year
    # adjust age if birthday hasn't occurred yet this year
    age -= 1 if birthdate > today - age.years
    age
  end

  private

  # PHOTO SCOPES
  # Validates that the user is at least 18 years old
  def must_be_18_or_older
    errors.add(:birthdate, 'must be 18 or older') if age && age < 18
  end

  # user creates with role 'user' by default
  def set_default_role
    self.role ||= 'user'
  end

  def mobile_number_valid
    return if mobile.blank?
    digits = mobile.gsub(/\D/, '')
    unless digits.length.between?(10, 15)
      errors.add(:mobile, "must have 10-15 digits")
    end
  end

  public

  # PHOTO-RELATED METHODS
  # a method that returns the primary photo of the user
  def primary_photo
    photos.find_by(is_primary: true) || photos.ordered.first
  end

  # a method that returns URLs of all photos of the user
  def photo_urls
    photos.ordered.map do |photo|
      Rails.application.routes.url_helpers.url_for(photo.image) if photo.image.attached?
    end.compact
  end

  # MATCH-RELATED METHODS
  # a method that returns all matches involving this user
  def all_matches
    Match.where('user1_id = ? OR user2_id = ?', id, id)
  end

  # a method that returns all users matched with this user
  def matched_users
    all_matches.map { |match| match.other_user(id) }
  end

  # MESSAGE-RELATED METHODS
  def unread_messages_count
    received_messages.unread.count
  end
end
