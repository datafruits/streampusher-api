class DropRecurringColumnFromScheduledShows < ActiveRecord::Migration
  def change
    remove_column :scheduled_shows, :recurring
  end
end
