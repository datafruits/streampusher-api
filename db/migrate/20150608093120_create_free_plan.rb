class CreateFreePlan < ActiveRecord::Migration
  def up
    Plan.create name: "Free Trial"
  end
  def down
    Plan.find_by_name("Free Trial").destroy
  end
end
