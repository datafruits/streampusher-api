class RenameShowSeriesImageColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :show_series, :image_update_at, :image_updated_at
  end
end
