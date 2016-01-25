class AddPlaylistIdToScheduledShows < ActiveRecord::Migration
  def change
    add_column :scheduled_shows, :playlist_id, :integer
  end
end
