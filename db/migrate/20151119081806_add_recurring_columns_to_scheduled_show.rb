class AddRecurringColumnsToScheduledShow < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :recurring, :boolean, null: false, default: false
    add_column :scheduled_shows, :recurring_interval, :integer, null: false, default: 0
  end
end
