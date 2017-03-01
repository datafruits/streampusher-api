class AddTagProcessingStatusToTracks < ActiveRecord::Migration[4.2]
  def change
    add_column :tracks, :tag_processing_status, :integer, null: false, default: 0
  end
end
