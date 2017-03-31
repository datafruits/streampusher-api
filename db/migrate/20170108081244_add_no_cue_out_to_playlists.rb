class AddNoCueOutToPlaylists < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :no_cue_out, :boolean, default: false, null: false
  end
end
