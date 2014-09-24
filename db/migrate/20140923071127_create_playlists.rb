class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :radio_id, null: false

      t.timestamps
    end
  end
end
