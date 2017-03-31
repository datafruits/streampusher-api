class AddEnabledToRadio < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :enabled, :boolean, null: false, default: true
  end
end
