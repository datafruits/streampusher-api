class AddId3TagsToAudioFileNameToTracks < ActiveRecord::Migration
  def self.up
    remove_column :tracks, :artist
    remove_column :tracks, :title
    add_id3_tags :tracks
  end

  def self.down
    remove_id3_tags :tracks
  end
end
