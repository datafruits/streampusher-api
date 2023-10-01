class AddActiveToShowSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :show_series, :status, :integer, default: 0, null: false
  end
end
