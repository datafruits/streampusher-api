class AddTrackIdToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_column :recordings, :track_id, :integer
  end
end
