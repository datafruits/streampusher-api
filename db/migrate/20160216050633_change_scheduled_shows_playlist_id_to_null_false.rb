class ChangeScheduledShowsPlaylistIdToNullFalse < ActiveRecord::Migration
  def change
    ScheduledShow.find_each do |scheduled_show|
      if scheduled_show.playlist_id.nil?
        scheduled_show.update_column :playlist_id, scheduled_show.radio.default_playlist_id
      end
    end
    change_column_default :scheduled_shows, :playlist_id, null: false
  end
end
