class DropPublishDateFromTracks < ActiveRecord::Migration
  def change
    remove_column :tracks, :publish_date
  end
end
