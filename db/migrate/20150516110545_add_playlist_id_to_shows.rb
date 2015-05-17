class AddPlaylistIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :playlist_id, :integer
  end
end
