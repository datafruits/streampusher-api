class AddPublishDateToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :publish_date, :datetime
  end
end
