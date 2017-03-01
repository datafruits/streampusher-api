class AddPodcastPublishedDateToPlaylistTracks < ActiveRecord::Migration[4.2]
  def change
    add_column :playlist_tracks, :podcast_published_date, :datetime
  end
end
