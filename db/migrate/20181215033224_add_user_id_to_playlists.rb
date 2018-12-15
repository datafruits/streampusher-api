class AddUserIdToPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :user_id, :integer, null: true, index: true
  end
end
