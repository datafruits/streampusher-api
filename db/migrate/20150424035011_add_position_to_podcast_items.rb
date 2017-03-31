class AddPositionToPodcastItems < ActiveRecord::Migration[4.2]
  def change
    add_column :podcast_items, :position, :integer
  end
end
