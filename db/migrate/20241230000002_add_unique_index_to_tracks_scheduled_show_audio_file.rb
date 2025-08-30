class AddUniqueIndexToTracksScheduledShowAudioFile < ActiveRecord::Migration[7.0]
  def change
    # Add unique index on (scheduled_show_id, audio_file_name) to prevent duplicate audio files for same show
    add_index :tracks, [:scheduled_show_id, :audio_file_name], unique: true, 
              name: "index_tracks_on_scheduled_show_id_and_audio_file_name_unique"
  end
end