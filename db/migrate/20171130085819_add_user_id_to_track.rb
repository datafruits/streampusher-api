class AddUserIdToTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :tracks, :uploaded_by_id, :integer, index: true
  end
end
