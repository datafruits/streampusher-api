class AddUniqueIndexToTrackLabels < ActiveRecord::Migration[5.0]
  def change
    add_index :track_labels, [:track_id, :label_id], unique: true
  end
end
