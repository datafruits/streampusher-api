class AddSlugsToScheduledShows < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduled_shows, :slug, :string
    ScheduledShow.find_each do |scheduled_show|
      scheduled_show.save!
    end
  end
end
