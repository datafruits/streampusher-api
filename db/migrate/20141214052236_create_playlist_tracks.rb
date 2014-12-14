class CreatePlaylistTracks < ActiveRecord::Migration
  def change
    create_table :playlist_tracks do |t|
      t.integer :track_id, null: false
      t.integer :playlist_id, null: false

      t.timestamps
    end
  end
end
