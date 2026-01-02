class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mobile
      t.date :birthdate
      t.string :gender
      t.string :sexual_orientation
      t.string :gender_interest
      t.string :country
      t.string :state
      t.string :city
      t.string :school
      t.text :bio
      t.string :role
      t.string :password_digest

      t.timestamps
    end
  end
end
