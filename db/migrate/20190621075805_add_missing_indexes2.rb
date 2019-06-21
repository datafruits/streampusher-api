class AddMissingIndexes2 < ActiveRecord::Migration[5.0]
  def change
    add_index :playlists, :user_id
    add_index :recordings, :dj_id
    add_index :recordings, :radio_id
    add_index :recordings, :track_id
    add_index :scheduled_show_performers, [:scheduled_show_id, :user_id], name: "ssp_ssid_uid"
    add_index :track_labels, :label_id
    add_index :track_labels, :track_id
    add_index :tracks, :scheduled_show_id
    add_index :tracks, :uploaded_by_id
    add_index :user_radios, :radio_id
    add_index :user_radios, :user_id
  end
end
