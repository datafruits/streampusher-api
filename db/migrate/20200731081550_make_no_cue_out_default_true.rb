class MakeNoCueOutDefaultTrue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :playlists, :no_cue_out, true
  end
end
