class AddDescriptionToScheduledShows < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :description, :text
  end
end
