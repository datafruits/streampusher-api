class CreateListens < ActiveRecord::Migration[4.2]
  def change
    create_table :listens do |t|
      t.integer :radio_id
      t.string :ip_address

      t.timestamps
    end
  end
end
