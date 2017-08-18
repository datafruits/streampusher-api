class AddMissingIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :playlist_tracks, :playlist_id
    add_index :playlist_tracks, :track_id
    add_index :playlists, :interpolated_playlist_id
    add_index :playlists, :radio_id
    add_index :podcasts, :playlist_id
    add_index :podcasts, :radio_id
    add_index :radios, :default_playlist_id
    add_index :radios, :subscription_id
    add_index :scheduled_shows, :dj_id
    add_index :scheduled_shows, :playlist_id
    add_index :scheduled_shows, :radio_id
    add_index :scheduled_shows, :recurrant_original_id
    add_index :social_identities, :user_id
    add_index :subscriptions, :plan_id
    add_index :subscriptions, :user_id
    add_index :tracks, :radio_id
  end
end
