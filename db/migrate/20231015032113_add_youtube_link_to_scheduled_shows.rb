class AddYoutubeLinkToScheduledShows < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_shows, :youtube_link, :string
  end
end
