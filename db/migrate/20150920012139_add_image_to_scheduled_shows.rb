class AddImageToScheduledShows < ActiveRecord::Migration
  def self.up
    change_table :scheduled_shows do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :scheduled_shows, :image
  end
end
