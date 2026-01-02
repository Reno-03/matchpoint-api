class User < ApplicationRecord
  # used for password hashing and authentication  
  has_secure_password

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
end
