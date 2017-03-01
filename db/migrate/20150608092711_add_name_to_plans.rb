class AddNameToPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :plans, :name, :string, null: false, default: ""
  end
end
