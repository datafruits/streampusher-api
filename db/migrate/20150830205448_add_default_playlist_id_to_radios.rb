class AddDefaultPlaylistIdToRadios < ActiveRecord::Migration
  def change
    add_column :radios, :default_playlist_id, :integer
  end
end
