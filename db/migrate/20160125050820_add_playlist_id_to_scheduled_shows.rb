class AddPlaylistIdToScheduledShows < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :playlist_id, :integer
  end
end
