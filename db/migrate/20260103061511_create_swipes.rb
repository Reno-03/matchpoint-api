class CreateSwipes < ActiveRecord::Migration[8.1]
  def change
    create_table :swipes do |t|
      t.references :swiper, null: false, foreign_key: { to_table: :users }
      t.references :swiped, null: false, foreign_key: { to_table: :users }
      t.string :action

      t.timestamps
    end
    
    # Index, sorted list for fast searching 
    add_index :swipes, [:swiper_id, :swiped_id], unique: true
  end
end
