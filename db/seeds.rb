# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.find_or_create_by!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@matchpoint.com",
  password: "admin123",
  birthdate: "1990-01-01",
  gender: "Other",
  gender_interest: "Both",
  country: "PH",
  city: "Manila",
  role: "admin"
)

User.find_or_create_by!(
  first_name: "Loreen",
  last_name: "Yboa",
  email: "loreen@test.com",
  password: "password123",
  birthdate: "1990-01-01",
  gender: "Male",
  gender_interest: "Female",
  country: "PH",
  city: "Manila",
  role: "user"
)

User.find_or_create_by!(
  first_name: "Alice",
  last_name: "Smith",
  email: "alice@test.com",
  password: "password123",
  birthdate: "1990-01-01",
  gender: "Female",
  gender_interest: "Male",
  country: "PH",
  city: "Manila",
  role: "user"
)