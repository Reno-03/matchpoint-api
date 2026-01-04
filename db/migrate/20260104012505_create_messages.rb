class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :match, null: false, foreign_key: true
      t.text :content, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    # index for fast search of messages
    add_index :messages, [:match_id, :created_at]
    add_index :messages, [:receiver_id, :read]
  end
end
