class AddMessageKeyAndParamsToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :message_key, :string
    add_column :notifications, :message_params, :jsonb, default: {}
  end
end