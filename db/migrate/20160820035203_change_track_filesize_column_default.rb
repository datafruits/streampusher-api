class ChangeTrackFilesizeColumnDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_null :tracks, :filesize, false, 0
    change_column_default :tracks, :filesize, 0
  end
end
