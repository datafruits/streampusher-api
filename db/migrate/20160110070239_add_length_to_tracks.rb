class AddLengthToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :length, :integer
  end
end
