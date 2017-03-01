class AddExpFieldsToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :exp_month, :integer
    add_column :subscriptions, :exp_year, :integer
  end
end
