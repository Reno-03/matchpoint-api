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
  u.mobile = "09170000000"
  u.school = "Admin University"
  u.sexual_orientation = "Other"
  u.role = "admin"
end

puts "✅ Admin: #{admin.email}"

# Create Test Users
users_data = [
  { first_name: "Maria", last_name: "Santos", gender: "Female", gender_interest: "Male", city: "Manila", mobile: "09171234501", sexual_orientation: "Straight", school: "University of Manila" },
  { first_name: "Juan", last_name: "Cruz", gender: "Male", gender_interest: "Female", city: "Cebu", mobile: "09171234502", sexual_orientation: "Straight", school: "Cebu State College" },
  { first_name: "Sofia", last_name: "Reyes", gender: "Female", gender_interest: "Male", city: "Davao", mobile: "09171234503", sexual_orientation: "Straight", school: nil },
  { first_name: "Miguel", last_name: "Torres", gender: "Male", gender_interest: "Female", city: "Manila", mobile: "09171234504", sexual_orientation: "Straight", school: nil },
  { first_name: "Isabella", last_name: "Garcia", gender: "Female", gender_interest: "Both", city: "Cebu", mobile: "09171234505", sexual_orientation: "Bisexual", school: "Cebu High School" }
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
    u.mobile = data[:mobile]
    u.school = data[:school]
    u.sexual_orientation = data[:sexual_orientation]
    u.role = "user"
  end
end

puts "✅ Created #{users_data.count} test users"

puts "\n👥 Creating 10 fixed test users..."

fixed_users = [
  { first_name: "Casey", last_name: "Lopez", gender: "Female", gender_interest: "Both", city: "Bacolod", mobile: "09171234511", sexual_orientation: "Bisexual", school: "Bacolod College" },
  { first_name: "Morgan", last_name: "Garcia", gender: "Male", gender_interest: "Female", city: "Cagayan", mobile: "09171234512", sexual_orientation: "Straight", school: nil },
  { first_name: "Riley", last_name: "Perez", gender: "Female", gender_interest: "Male", city: "Zamboanga", mobile: "09171234513", sexual_orientation: "Straight", school: "Zamboanga University" },
  { first_name: "Sam", last_name: "Flores", gender: "Male", gender_interest: "Female", city: "Dumaguete", mobile: "09171234514", sexual_orientation: "Straight", school: nil },
  { first_name: "Dylan", last_name: "Ramos", gender: "Male", gender_interest: "Female", city: "Manila", mobile: "09171234515", sexual_orientation: "Straight", school: "Manila Tech" },

  { first_name: "Avery", last_name: "Santos", gender: "Female", gender_interest: "Both", city: "Cebu", mobile: "09171234516", sexual_orientation: "Bisexual", school: nil },
  { first_name: "Quinn", last_name: "Reyes", gender: "Male", gender_interest: "Female", city: "Davao", mobile: "09171234517", sexual_orientation: "Straight", school: "Davao College" },
  { first_name: "Devon", last_name: "Villanueva", gender: "Male", gender_interest: "Both", city: "Dumaguete", mobile: "09171234518", sexual_orientation: "Bisexual", school: nil },
  { first_name: "Logan", last_name: "Castillo", gender: "Male", gender_interest: "Female", city: "Manila", mobile: "09171234519", sexual_orientation: "Straight", school: "Manila High School" },
  { first_name: "Harper", last_name: "Aquino", gender: "Female", gender_interest: "Both", city: "Cebu", mobile: "09171234520", sexual_orientation: "Bisexual", school: nil }
]

fixed_users.each do |data|
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
    u.mobile = data[:mobile]
    u.school = data[:school]
    u.sexual_orientation = data[:sexual_orientation]
    u.role = "user"
  end
end

puts "✅ Created #{fixed_users.count} fixed test users"

puts "\n🎉 Seeding complete!"
