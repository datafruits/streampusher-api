class CreateUserRadios < ActiveRecord::Migration
  def change
    create_table :user_radios do |t|
      t.integer :user_id, null: false
      t.integer :radio_id, null: false

      t.timestamps
    end
  end
end
