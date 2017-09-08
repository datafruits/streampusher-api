class CreateMissingPlan < ActiveRecord::Migration[5.0]
  class Plan < ActiveRecord::Base; end
  def change
    Plan.create name: "Premium", price: 49.00
  end
end
