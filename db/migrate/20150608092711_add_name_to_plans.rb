class AddNameToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :name, :string, null: false, default: ""
  end
end
