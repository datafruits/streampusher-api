class AddPortNumberToRadios < ActiveRecord::Migration[5.0]
  def change
    add_column :radios, :port_number, :integer
  end
end
