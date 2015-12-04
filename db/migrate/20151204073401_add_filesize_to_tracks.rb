class AddFilesizeToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :filesize, :integer
  end
end
