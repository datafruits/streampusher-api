class AddTimeColumnsToShowSeries < ActiveRecord::Migration[6.1]
  def change
    # idk if these should be dates or strings
    add_column :show_series, :start_time, :datetime, null: false
    add_column :show_series, :end_time, :datetime, null: false
    add_column :show_series, :start_date, :datetime, null: false
    add_column :show_series, :end_date, :datetime
  end
end
