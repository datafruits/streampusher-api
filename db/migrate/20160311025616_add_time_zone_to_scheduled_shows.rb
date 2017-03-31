class AddTimeZoneToScheduledShows < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :time_zone, :string
  end
end
