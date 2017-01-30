class DropShowIdFromRecordings < ActiveRecord::Migration
  def change
    remove_column :recordings, :show_id
  end
end
