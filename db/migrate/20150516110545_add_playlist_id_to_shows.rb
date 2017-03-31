class AddPlaylistIdToShows < ActiveRecord::Migration[4.2]
  def change
    add_column :shows, :playlist_id, :integer
  end
end
