class AddRadioIdIndexToLabels < ActiveRecord::Migration[5.0]
  def change
    add_index :labels, :radio_id
  end
end
