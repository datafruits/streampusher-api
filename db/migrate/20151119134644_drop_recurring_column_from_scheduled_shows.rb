class DropRecurringColumnFromScheduledShows < ActiveRecord::Migration[4.2]
  def change
    remove_column :scheduled_shows, :recurring
  end
end
