class AddRefererToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :referer, :string
  end
end
