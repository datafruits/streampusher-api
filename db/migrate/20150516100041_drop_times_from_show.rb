class DropTimesFromShow < ActiveRecord::Migration[4.2]
  def change
    remove_column :shows, :start_at
    remove_column :shows, :end_at
  end
end
