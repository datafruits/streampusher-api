class AddExpPointsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :experience_points, :integer, default: 0, null: false
    add_column :users, :level, :integer, default: 0, null: false
  end
end
