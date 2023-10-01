class AddDefaultPlaylistIdToShowSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :show_series, :default_playlist_id, :integer
  end
end
