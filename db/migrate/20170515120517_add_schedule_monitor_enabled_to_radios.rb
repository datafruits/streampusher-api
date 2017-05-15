class AddScheduleMonitorEnabledToRadios < ActiveRecord::Migration[5.0]
  def change
    add_column :radios, :schedule_monitor_enabled, :boolean, null: false, default: false
  end
end
