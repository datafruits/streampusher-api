class AddNoCueOutToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :no_cue_out, :boolean, default: false, null: false
  end
end
