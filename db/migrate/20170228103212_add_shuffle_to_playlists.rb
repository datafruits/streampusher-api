class AddShuffleToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :shuffle, :boolean, default: false, null: false
  end
end
