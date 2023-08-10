class AddSourceTypeToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :source_type, :string
  end
end
