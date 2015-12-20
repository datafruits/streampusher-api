class AddTagProcessingStatusToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :tag_processing_status, :integer, null: false, default: 0
  end
end
