class AddLengthToTracks < ActiveRecord::Migration[4.2]
  def change
    unless column_exists? :tracks, :length
      add_column :tracks, :length, :integer
    end
  end
end
