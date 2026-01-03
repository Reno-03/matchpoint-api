# Clear existing data
User.destroy_all
Swipe.destroy_all
Photo.destroy_all
Match.destroy_all

# Create Admin
admin = User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@matchpoint.com",
  password: "admin123",
  birthdate: "1990-01-01",
  gender: "Other",
  gender_interest: "Both",
  country: "Philippines",
  city: "Manila",
  role: "admin"
)

puts "✅ Admin created: #{admin.email}"

# Create Test Users
users_data = [
  { first_name: "Maria", last_name: "Santos", gender: "Female", gender_interest: "Male", city: "Manila" },
  { first_name: "Juan", last_name: "Cruz", gender: "Male", gender_interest: "Female", city: "Cebu" },
  { first_name: "Sofia", last_name: "Reyes", gender: "Female", gender_interest: "Male", city: "Davao" },
  { first_name: "Miguel", last_name: "Torres", gender: "Male", gender_interest: "Female", city: "Manila" },
  { first_name: "Isabella", last_name: "Garcia", gender: "Female", gender_interest: "Both", city: "Cebu" },
  { first_name: "Loreen", last_name: "Yboa", gender: "Male", gender_interest: "Female", city: "Catbalogan" },
]

users_data.each_with_index do |data, index|
  user = User.create!(
    first_name: data[:first_name],
    last_name: data[:last_name],
    email: "#{data[:first_name].downcase}@test.com",
    password: "password123",
    birthdate: "1998-01-01",
    gender: data[:gender],
    gender_interest: data[:gender_interest],
    country: "Philippines",
    city: data[:city],
    bio: "Hi! I'm #{data[:first_name]} from #{data[:city]}.",
    role: "user"
  )
  
  puts "✅ User created: #{user.email}"
end

puts "\n🎉 Seeding complete!"
puts "Total users: #{User.count}"