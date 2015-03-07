class DropVirtualhostFromRadios < ActiveRecord::Migration
  def change
    remove_column :radios, :virtual_host
  end
end
