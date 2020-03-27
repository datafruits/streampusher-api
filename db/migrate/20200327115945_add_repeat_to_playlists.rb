class AddRepeatToPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :repeat, :boolean, default: false, null: false
  end
end
