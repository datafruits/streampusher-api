class DropPodcastItems < ActiveRecord::Migration
  def change
    drop_table :podcast_items
  end
end
