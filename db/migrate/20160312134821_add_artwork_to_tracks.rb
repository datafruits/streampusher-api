class AddArtworkToTracks < ActiveRecord::Migration[4.2]
  def self.up
    change_table :tracks do |t|
      t.attachment :artwork
    end
  end

  def self.down
    remove_attachment :tracks, :artwork
  end
end
