class FruitTicketBalances < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :fruit_ticket_balance, :integer, default: 0, null: false
  end
end
