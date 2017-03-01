class AddInterpolatedPlaylistIdToPlaylist < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :interpolated_playlist_id, :integer
    add_column :playlists, :interpolated_playlist_track_play_count, :integer
    add_column :playlists, :interpolated_playlist_track_interval_count, :integer
  end
end
