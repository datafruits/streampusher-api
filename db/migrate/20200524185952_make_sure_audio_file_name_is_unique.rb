class MakeSureAudioFileNameIsUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :tracks, [:audio_file_name, :id], unique: true
  end
end
