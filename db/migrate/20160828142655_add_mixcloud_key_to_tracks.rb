class AddMixcloudKeyToTracks < ActiveRecord::Migration[4.2]
  def change
    add_column :tracks, :mixcloud_key, :string
  end
end
