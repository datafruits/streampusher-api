class AddVirtualHostToRadio < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :virtual_host, :string
  end
end
