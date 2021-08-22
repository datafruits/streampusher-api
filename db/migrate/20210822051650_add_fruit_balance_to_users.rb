class AddFruitBalanceToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fruit_balance, :integer, default: 0, null: false
  end
end
