class AddRecordingIdToScheduledShow < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_shows, :recording_id, :integer
  end
end
