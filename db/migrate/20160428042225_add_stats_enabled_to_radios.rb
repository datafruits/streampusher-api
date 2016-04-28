class AddStatsEnabledToRadios < ActiveRecord::Migration
  def change
    add_column :radios, :stats_enabled, :boolean, default: false, null: false
  end
end
