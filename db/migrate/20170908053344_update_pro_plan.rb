class UpdateProPlan < ActiveRecord::Migration[5.0]
  def change
    plan = Plan.find_by(name: "Pro")
    plan.update(name: "Professional", price: 79.00)
  end
end
