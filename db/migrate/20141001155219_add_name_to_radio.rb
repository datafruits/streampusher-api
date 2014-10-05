class AddNameToRadio < ActiveRecord::Migration
  def change
    add_column :radios, :name, :string, null: false, default: ''
  end
end
