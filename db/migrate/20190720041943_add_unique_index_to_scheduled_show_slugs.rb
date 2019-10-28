class AddUniqueIndexToScheduledShowSlugs < ActiveRecord::Migration[5.0]
  def change
    add_index :scheduled_shows, [:slug, :id], unique: true
  end
end
