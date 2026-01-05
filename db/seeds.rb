# db/seeds.rb
Message.delete_all
Match.delete_all
Swipe.delete_all
Photo.delete_all
User.delete_all

# Reset primary key sequences for Postgres
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('photos')
ActiveRecord::Base.connection.reset_pk_sequence!('swipes')
ActiveRecord::Base.connection.reset_pk_sequence!('matches')

# Create Admin
admin = User.find_or_create_by!(email: "admin@matchpoint.com") do |u|
  u.first_name = "Admin"
  u.last_name = "User"
  u.password = "admin123"
  u.birthdate = "1990-01-01"
  u.gender = "Other"
  u.gender_interest = "Both"
  u.country = "Philippines"
  u.city = "Manila"
  u.role = "admin"
end

puts "✅ Admin: #{admin.email}"

# Create Test Users
users_data = [
  { first_name: "Maria", last_name: "Santos", gender: "Female", gender_interest: "Male", city: "Manila" },
  { first_name: "Juan", last_name: "Cruz", gender: "Male", gender_interest: "Female", city: "Cebu" },
  { first_name: "Sofia", last_name: "Reyes", gender: "Female", gender_interest: "Male", city: "Davao" },
  { first_name: "Miguel", last_name: "Torres", gender: "Male", gender_interest: "Female", city: "Manila" },
  { first_name: "Isabella", last_name: "Garcia", gender: "Female", gender_interest: "Both", city: "Cebu" },
]

users_data.each do |data|
  User.find_or_create_by!(email: "#{data[:first_name].downcase}@test.com") do |u|
    u.first_name = data[:first_name]
    u.last_name = data[:last_name]
    u.password = "password123"
    u.birthdate = "1998-01-01"
    u.gender = data[:gender]
    u.gender_interest = data[:gender_interest]
    u.country = "Philippines"
    u.city = data[:city]
    u.bio = "Hi! I'm #{data[:first_name]} from #{data[:city]}."
    u.role = "user"
  end
end

puts "✅ Created #{users_data.count} test users"

puts "\n👥 Creating 10 fixed test users..."

fixed_users = [
  { first_name: "Casey", last_name: "Lopez", gender: "Female", gender_interest: "Both", city: "Bacolod" },
  { first_name: "Morgan", last_name: "Garcia", gender: "Male", gender_interest: "Female", city: "Cagayan" },
  { first_name: "Riley", last_name: "Perez", gender: "Female", gender_interest: "Male", city: "Zamboanga" },
  { first_name: "Sam", last_name: "Flores", gender: "Male", gender_interest: "Female", city: "Dumaguete" },
  { first_name: "Dylan", last_name: "Ramos", gender: "Male", gender_interest: "Female", city: "Manila" },

  { first_name: "Avery", last_name: "Santos", gender: "Female", gender_interest: "Both", city: "Cebu" },
  { first_name: "Quinn", last_name: "Reyes", gender: "Male", gender_interest: "Female", city: "Davao" },
  { first_name: "Devon", last_name: "Villanueva", gender: "Male", gender_interest: "Both", city: "Dumaguete" },
  { first_name: "Logan", last_name: "Castillo", gender: "Male", gender_interest: "Female", city: "Manila" },
  { first_name: "Harper", last_name: "Aquino", gender: "Female", gender_interest: "Both", city: "Cebu" }
]

fixed_users.each_with_index do |data, index|
  User.find_or_create_by!(email: "#{data[:first_name].downcase}@test.com") do |u|
    u.first_name = data[:first_name]
    u.last_name = data[:last_name]
    u.password = "password123"
    u.birthdate = "1997-01-01"
    u.gender = data[:gender]
    u.gender_interest = data[:gender_interest]
    u.country = "Philippines"
    u.city = data[:city]
    u.bio = "Hi! I'm #{data[:first_name]} from #{data[:city]}."
    u.role = "user"
  end
end

puts "✅ Created #{fixed_users.count} fixed test users"

puts "\n🎉 Seeding complete!"