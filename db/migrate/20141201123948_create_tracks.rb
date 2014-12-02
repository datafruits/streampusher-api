class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :artist
      t.string :title
      t.string :audio_file_name
      t.references :radio

      t.timestamps
    end
  end
end
