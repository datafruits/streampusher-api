class CreateRadios < ActiveRecord::Migration[4.2]
  def change
    create_table :radios do |t|
      t.integer :user_id, null: false
      t.string :docker_container_id

      t.timestamps
    end
  end
end
