class AddNameToPlaylists < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :name, :string
  end
end
