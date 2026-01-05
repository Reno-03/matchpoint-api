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

puts "✅ Created #{users_data.count} test users"

puts "\n👥 Creating 20 additional test users..."

first_names = %w[
  Alex Jamie Chris Taylor Jordan Casey Morgan Riley Sam Dylan
  Avery Quinn Parker Reese Rowan Skyler Cameron Devon Logan
]

last_names = %w[
  Miller Anderson Brown Wilson Martinez Lopez Garcia Perez Flores Ramos
]

cities = %w[
  Manila Cebu Davao Baguio Iloilo Bacolod Cagayan Zamboanga Dumaguete
]

genders = ["Male", "Female"]
gender_interests = ["Male", "Female", "Both"]

20.times do |i|
  first_name = first_names.sample
  last_name = last_names.sample

  User.create!(
    email: "user#{i + 1}@test.com",
    first_name: first_name,
    last_name: last_name,
    password: "password123",
    birthdate: Date.new(rand(1990..2002), rand(1..12), rand(1..28)),
    gender: genders.sample,
    gender_interest: gender_interests.sample,
    country: "Philippines",
    city: cities.sample,
    bio: "Hey! I'm #{first_name} and I love meeting new people.",
    role: "user"
  )
end

puts "✅ Created 20 additional test users"


# Create Maria and Juan match
puts "\n💘 Creating Maria and Juan match..."

maria = User.find_by(email: "maria@test.com")
juan = User.find_by(email: "juan@test.com")

if maria && juan
  # Maria likes Juan
  swipe1 = Swipe.create!(
    swiper: maria,
    swiped: juan,
    action: 'like'
  )
  puts "✅ Maria liked Juan"

  # Juan likes Maria back (creates match automatically)
  swipe2 = Swipe.create!(
    swiper: juan,
    swiped: maria,
    action: 'like'
  )
  puts "✅ Juan liked Maria back"
  
  match = Match.where('(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)', 
                       maria.id, juan.id, juan.id, maria.id).first
  
  if match
    puts "🎉 Match created! ID: #{match.id}"
  end
end

puts "\n📨 Creating sample messages..."

# Get the Maria-Juan match
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

  puts "✅ Created #{messages.count} messages between #{sender.first_name} and #{receiver.first_name}"
end

puts "\n🎉 Seeding complete!"
puts "📊 Final counts:"
puts "  Users: #{User.count}"
puts "  Swipes: #{Swipe.count}"
puts "  Matches: #{Match.count}"
puts "  Messages: #{Message.count}"