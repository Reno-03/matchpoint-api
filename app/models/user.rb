class User < ApplicationRecord
  # used for password hashing and authentication  
  has_secure_password

  has_many :photos, dependent: :destroy
  has_many :swipes_made, class_name: 'Swipe', foreign_key: 'swiper_id', dependent: :destroy
  has_many :swipes_received, class_name: 'Swipe', foreign_key: 'swiped_id', dependent: :destroy
  has_many :matches, dependent: :destroy

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
  
  validates :photos, length: { minimum: 1, maximum: 5, message: 'must have 1-5 photos' }

  # this function calculates the age of the user based on birthdate
  def age
    return unless birthdate
    today = Date.today
    age = today.year - birthdate.year
    age -= 1 if birthdate > today - age.years
    age
  end

  private

  # Validates that the user is at least 18 years old
  def must_be_18_or_older
    errors.add(:birthdate, 'must be 18 or older') if age && age < 18
  end

  # user creates with role 'user' by default
  def set_default_role
    self.role ||= 'user'
  end

  public
  def primary_photo
    photos.find_by(is_primary: true) || photos.ordered.first
  end

  def photo_urls
    photos.ordered.map do |photo|
      Rails.application.routes.url_helpers.url_for(photo.image) if photo.image.attached?
    end.compact
  end
end
