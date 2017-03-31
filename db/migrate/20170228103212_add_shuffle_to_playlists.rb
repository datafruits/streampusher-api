class AddShuffleToPlaylists < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :shuffle, :boolean, default: false, null: false
  end
end
