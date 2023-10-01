class RemoveRecurringColumnFromShowSeries < ActiveRecord::Migration[7.0]
  def change
    remove_column :show_series, :recurring
  end
end
