class CreatePaidPlans < ActiveRecord::Migration[4.2]
  class Plan < ActiveRecord::Base
  end
  def change
    Plan.create name: "Hobbyist", price: 19.00
    Plan.create name: "Pro", price: 39.00
  end
end
