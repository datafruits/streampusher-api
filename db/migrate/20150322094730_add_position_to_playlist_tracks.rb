class AddPositionToPlaylistTracks < ActiveRecord::Migration
  def change
    add_column :playlist_tracks, :position, :integer
  end
end
