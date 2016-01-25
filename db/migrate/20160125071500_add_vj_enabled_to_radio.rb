class AddVjEnabledToRadio < ActiveRecord::Migration
  def change
    add_column :radios, :vj_enabled, :boolean, default: false, null: false
  end
end
