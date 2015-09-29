class AddInterpolatedPlaylistEnabledToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :interpolated_playlist_enabled, :boolean, default: false, null: false
  end
end
