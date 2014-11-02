class CreateListens < ActiveRecord::Migration
  def change
    create_table :listens do |t|
      t.integer :radio_id
      t.string :ip_address

      t.timestamps
    end
  end
end
