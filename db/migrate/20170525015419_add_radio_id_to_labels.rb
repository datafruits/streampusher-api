class AddRadioIdToLabels < ActiveRecord::Migration[5.0]
  def change
    add_column :labels, :radio_id, :integer, null: false
  end
end
