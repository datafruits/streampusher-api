class DropPublishDateFromTracks < ActiveRecord::Migration[4.2]
  def change
    remove_column :tracks, :publish_date
  end
end
