class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :position, default: 0
      t.boolean :is_primary, default: false

      t.timestamps
    end

    # Index, sorted list for fast searching 
    add_index :photos, [:user_id, :position]
  end
end
