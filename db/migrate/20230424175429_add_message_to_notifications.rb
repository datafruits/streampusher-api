class AddMessageToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :message, :string, null: false
  end
end
