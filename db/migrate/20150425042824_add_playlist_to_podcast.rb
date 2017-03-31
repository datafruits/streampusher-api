class AddPlaylistToPodcast < ActiveRecord::Migration[4.2]
  def change
    add_column :podcasts, :playlist_id, :integer
  end
end
