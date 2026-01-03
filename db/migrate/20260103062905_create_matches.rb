class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    # Ensure uniqueness of matches between two users
    add_index :matches, [:user1_id, :user2_id], unique: true
  end
end
