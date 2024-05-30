class AddTimezoneToShowSeries < ActiveRecord::Migration[7.0]
  def change
    add_column :show_series, :time_zone, :string, default: "UTC", null: false
  end
end
