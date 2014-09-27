class CreateRadios < ActiveRecord::Migration
  def change
    create_table :radios do |t|
      t.integer :user_id, null: false
      t.string :docker_container_id

      t.timestamps
    end
  end
end
