class AddInterpolatedPlaylistEnabledToPlaylists < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :interpolated_playlist_enabled, :boolean, default: false, null: false
  end
end
