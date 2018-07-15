class AddScheduledShowIdToTracks < ActiveRecord::Migration[5.0]
  def change
    add_column :tracks, :scheduled_show_id, :integer
  end
end
