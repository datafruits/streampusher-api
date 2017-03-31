class AddVjEnabledToRadio < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :vj_enabled, :boolean, default: false, null: false
  end
end
