class ChangeTrackFilesizeColumnDefault < ActiveRecord::Migration
  def change
    change_column_null :tracks, :filesize, false, 0
    change_column_default :tracks, :filesize, 0
  end
end
