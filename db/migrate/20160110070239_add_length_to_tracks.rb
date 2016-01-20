class AddLengthToTracks < ActiveRecord::Migration
  def change
    unless column_exists? :tracks, :length
      add_column :tracks, :length, :integer
    end
  end
end
