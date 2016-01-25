class AddDjIdToScheduledShows < ActiveRecord::Migration
  def change
    add_column :scheduled_shows, :dj_id, :integer
  end
end
