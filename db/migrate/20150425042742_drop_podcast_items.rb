class DropPodcastItems < ActiveRecord::Migration[4.2]
  def change
    drop_table :podcast_items
  end
end
