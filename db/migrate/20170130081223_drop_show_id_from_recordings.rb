class DropShowIdFromRecordings < ActiveRecord::Migration[4.2]
  def change
    remove_column :recordings, :show_id
  end
end
