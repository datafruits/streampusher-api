class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false
      t.integer :notification_type, null: false
      t.boolean :send_to_chat, null: false, default: false
      t.boolean :send_to_user, null: false, default: true
      t.integer :source_id

      t.timestamps
    end
  end
end
