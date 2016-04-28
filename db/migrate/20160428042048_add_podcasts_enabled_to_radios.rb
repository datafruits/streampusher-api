class AddPodcastsEnabledToRadios < ActiveRecord::Migration
  def change
    add_column :radios, :podcasts_enabled, :boolean, default: false, null: false
  end
end
