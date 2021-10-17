class AddArchivedToMicrotexts < ActiveRecord::Migration[5.1]
  def change
    add_column :microtexts, :archived, :boolean, default: false, null: false
  end
end
