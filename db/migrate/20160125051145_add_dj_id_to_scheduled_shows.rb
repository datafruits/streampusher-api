class AddDjIdToScheduledShows < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :dj_id, :integer
  end
end
