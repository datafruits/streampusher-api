class AddIsLiveToScheduledShow < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduled_shows, :is_live, :boolean, default: false, null: false
  end
end
