class AddExpFieldsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :exp_month, :integer
    add_column :subscriptions, :exp_year, :integer
  end
end
