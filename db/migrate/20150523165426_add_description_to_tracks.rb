class AddDescriptionToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :description, :string, null: false, default: ""
  end
end
