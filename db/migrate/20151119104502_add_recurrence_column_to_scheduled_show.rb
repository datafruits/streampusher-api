class AddRecurrenceColumnToScheduledShow < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :recurrence, :boolean, null: false, default: false
    add_column :scheduled_shows, :recurrant_original_id, :integer
  end
end
