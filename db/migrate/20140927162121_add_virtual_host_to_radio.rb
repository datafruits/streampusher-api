class AddVirtualHostToRadio < ActiveRecord::Migration
  def change
    add_column :radios, :virtual_host, :string
  end
end
