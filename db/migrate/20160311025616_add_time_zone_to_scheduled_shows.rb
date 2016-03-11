class AddTimeZoneToScheduledShows < ActiveRecord::Migration
  def change
    add_column :scheduled_shows, :time_zone, :string
  end
end
