class AddMissingIndexesAgain < ActiveRecord::Migration[7.0]
  def change
    def change
      add_index :active_storage_attachments, [:record_id, :record_type]
      add_index :active_storage_variant_records, :blob_id
      add_index :experience_point_awards, [:source_id, :source_type]
      add_index :fruit_ticket_transactions, :from_user_id
      add_index :fruit_ticket_transactions, :to_user_id
      add_index :notifications, [:source_id, :source_type]
      add_index :scheduled_show_performers, [:user_id, :user_id]
      add_index :scheduled_shows, :recording_id
      add_index :scheduled_shows, :show_series_id
      add_index :show_series, :default_playlist_id
      add_index :show_series, :radio_id
    end
  end
end
