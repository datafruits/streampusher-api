class AddRecurringColumnsToShowSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :show_series, :recurring, :boolean, null: false, default: false
    add_column :show_series, :recurring_interval, :integer, null: false, default: 0
    add_column :show_series, :recurring_weekday, :integer, null: false, default: 0
    add_column :show_series, :recurring_cadence, :integer, null: false, default: 0
  end
end
