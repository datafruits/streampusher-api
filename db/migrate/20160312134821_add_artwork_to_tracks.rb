class AddArtworkToTracks < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.attachment :artwork
    end
  end

  def self.down
    remove_attachment :tracks, :artwork
  end
end
