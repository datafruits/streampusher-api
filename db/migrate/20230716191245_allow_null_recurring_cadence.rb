class AllowNullRecurringCadence < ActiveRecord::Migration[6.1]
  def change
    change_column_null :show_series, :recurring_cadence, true
  end
end
