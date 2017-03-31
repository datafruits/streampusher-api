class AddStatsEnabledToRadios < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :stats_enabled, :boolean, default: false, null: false
  end
end
