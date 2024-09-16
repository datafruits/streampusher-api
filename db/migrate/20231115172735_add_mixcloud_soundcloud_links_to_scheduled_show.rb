class AddMixcloudSoundcloudLinksToScheduledShow < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_shows, :mixcloud_link, :string
    add_column :scheduled_shows, :soundcloud_link, :string
  end
end
