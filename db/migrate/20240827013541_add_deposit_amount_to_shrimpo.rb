class AddDepositAmountToShrimpo < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :deposit_amount, :integer
  end
end
