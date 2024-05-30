class AddYoutubeLinkToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :youtube_link, :string
  end
end
