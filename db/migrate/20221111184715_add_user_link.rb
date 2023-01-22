class AddUserLink < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :homepage, :string
  end
end
