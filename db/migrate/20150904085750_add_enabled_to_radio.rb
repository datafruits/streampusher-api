class AddEnabledToRadio < ActiveRecord::Migration
  def change
    add_column :radios, :enabled, :boolean, null: false, default: true
  end
end
