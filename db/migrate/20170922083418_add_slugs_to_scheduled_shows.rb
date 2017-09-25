class AddSlugsToScheduledShows < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduled_shows, :slug, :string
  end
end
