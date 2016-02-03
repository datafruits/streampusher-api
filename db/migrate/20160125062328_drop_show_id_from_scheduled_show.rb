class DropShowIdFromScheduledShow < ActiveRecord::Migration
  def change
    remove_column :scheduled_shows, :show_id
  end
end
