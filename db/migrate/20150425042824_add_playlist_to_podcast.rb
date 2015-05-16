class AddPlaylistToPodcast < ActiveRecord::Migration
  def change
    add_column :podcasts, :playlist_id, :integer
  end
end
