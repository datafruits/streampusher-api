class AddRadioIdToShowSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :show_series, :radio_id, :integer, null: false, default: 1
  end
end
