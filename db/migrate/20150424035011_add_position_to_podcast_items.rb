class AddPositionToPodcastItems < ActiveRecord::Migration
  def change
    add_column :podcast_items, :position, :integer
  end
end
