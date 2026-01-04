# db/seeds.rb
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
  { first_name: "Loreen", last_name: "Yboa", gender: "Male", gender_interest: "Female", city: "Catbalogan" },
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

puts "🎉 Total users: #{User.count}"

puts "\n📨 Creating sample messages..."

# Get first two users who have a match
match = Match.first
if match
  sender = match.user1
  receiver = match.user2

  messages = [
    "Hey! How's it going?",
    "Pretty good! Just got back from the gym. You?",
    "Nice! I'm just relaxing. Want to grab coffee sometime?",
    "That sounds great! How about this weekend?",
    "Perfect! I'll DM you the details."
  ]

  messages.each_with_index do |content, index|
    Message.create!(
      sender: index.even? ? sender : receiver,
      receiver: index.even? ? receiver : sender,
      match: match,
      content: content,
      read: index < 3  # First 3 messages are read
    )
  end

  puts "✅ Created #{messages.count} messages"
end

puts "\n🎉 Seeding complete!"
puts "📊 Final counts:"
puts "  Users: #{User.count}"
puts "  Swipes: #{Swipe.count}"
puts "  Matches: #{Match.count}"
puts "  Messages: #{Message.count}"