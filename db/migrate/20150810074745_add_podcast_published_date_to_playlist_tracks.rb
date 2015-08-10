class AddPodcastPublishedDateToPlaylistTracks < ActiveRecord::Migration
  def change
    add_column :playlist_tracks, :podcast_published_date, :datetime
  end
end
