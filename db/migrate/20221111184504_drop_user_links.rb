class DropUserLinks < ActiveRecord::Migration[5.2]
  def change
    drop_table :links
  end
end
