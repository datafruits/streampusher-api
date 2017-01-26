class AddSoundcloudStatusAndKeyToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :soundcloud_upload_status, :integer, default: 0, null: false
    add_column :tracks, :soundcloud_key, :string
  end
end
