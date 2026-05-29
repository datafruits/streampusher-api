class CreateUserAccessories < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accessories do |t|
      t.references :accessory
      t.references :user

      t.timestamps
    end
  end
end
