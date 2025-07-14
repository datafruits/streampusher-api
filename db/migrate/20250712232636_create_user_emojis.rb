class CreateUserEmojis < ActiveRecord::Migration[7.0]
  def change
    create_table :user_emojis do |t|
      t.references :user, null: false, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
