class AddMixcloudKeyToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :mixcloud_key, :string
  end
end
