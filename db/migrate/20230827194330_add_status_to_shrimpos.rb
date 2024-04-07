class AddStatusToShrimpos < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :status, :integer, default: 0, null: false
  end
end
