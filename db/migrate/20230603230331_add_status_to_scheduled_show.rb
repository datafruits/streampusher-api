class AddStatusToScheduledShow < ActiveRecord::Migration[6.1]
  def change
    add_column :scheduled_shows, :status, :integer, default: 0, null: false
  end
end
