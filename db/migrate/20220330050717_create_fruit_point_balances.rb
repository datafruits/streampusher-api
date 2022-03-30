class CreateFruitPointBalances < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fruit_balance, :integer, default: 0, null: false
  end
end
