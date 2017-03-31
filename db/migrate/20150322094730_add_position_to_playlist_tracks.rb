class AddPositionToPlaylistTracks < ActiveRecord::Migration[4.2]
  def change
    add_column :playlist_tracks, :position, :integer
  end
end
