class CreatePodcastItems < ActiveRecord::Migration[4.2]
  def change
    create_table :podcast_items do |t|
      t.references :podcast
      t.references :track

      t.timestamps
    end
  end
end
