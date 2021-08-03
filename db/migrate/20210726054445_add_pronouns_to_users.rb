class AddPronounsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pronouns, :string, default: "", null: false
  end
end
