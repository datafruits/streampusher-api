class AddNameToRadio < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :name, :string, null: false, default: ''
  end
end
