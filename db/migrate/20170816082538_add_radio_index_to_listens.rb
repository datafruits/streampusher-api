class AddRadioIndexToListens < ActiveRecord::Migration[5.0]
  def change
    add_index :listens, :radio_id
  end
end
