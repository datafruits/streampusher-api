class AddUniqueIndexToScheduledShowPerformers < ActiveRecord::Migration[5.0]
  def change
    add_index :scheduled_show_performers, [:user_id, :scheduled_show_id], unique: true, name: "index_scheduled_show_performers_on_uid_and_ssid"
  end
end
