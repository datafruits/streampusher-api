class CreateRadioServers < ActiveRecord::Migration
  def change
    create_table :radio_servers do |t|
      t.integer :user_id, null: false
      t.integer :docker_container_id

      t.timestamps
    end
  end
end
