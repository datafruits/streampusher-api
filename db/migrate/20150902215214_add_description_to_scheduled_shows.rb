class AddDescriptionToScheduledShows < ActiveRecord::Migration
  def change
    add_column :scheduled_shows, :description, :text
  end
end
