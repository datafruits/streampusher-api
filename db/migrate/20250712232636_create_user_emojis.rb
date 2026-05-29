class CreateUserEmojis < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_emojis do |t|
      t.references :user, null: false, index: true
      t.string :name, null: false
    end

    create_table :user_emojis do |t|
      t.references :user, null: false, index: true
      t.references :custom_emoji, null: false, index: true

      t.timestamps
    end

    add_index :user_emojis, [:user_id, :custom_emoji_id], unique: true
  end
end
