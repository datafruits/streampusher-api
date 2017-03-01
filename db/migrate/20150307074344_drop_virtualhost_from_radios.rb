class DropVirtualhostFromRadios < ActiveRecord::Migration[4.2]
  def change
    remove_column :radios, :virtual_host
  end
end
