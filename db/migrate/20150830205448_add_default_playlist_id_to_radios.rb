class AddDefaultPlaylistIdToRadios < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :default_playlist_id, :integer
  end
end
