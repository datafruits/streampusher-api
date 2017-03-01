class AddPublishDateToTracks < ActiveRecord::Migration[4.2]
  def change
    add_column :tracks, :publish_date, :datetime
  end
end
