class AddUniqueIndexToRecordingsTrackId < ActiveRecord::Migration[7.0]
  def change
    # Add unique index on track_id to ensure one track is associated with only one recording
    add_index :recordings, :track_id, unique: true, name: "index_recordings_on_track_id_unique"
  end
end