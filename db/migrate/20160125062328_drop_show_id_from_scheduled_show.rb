class DropShowIdFromScheduledShow < ActiveRecord::Migration[4.2]
  def change
    remove_column :scheduled_shows, :show_id
  end
end
