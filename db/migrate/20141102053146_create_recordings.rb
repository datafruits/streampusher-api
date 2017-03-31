class CreateRecordings < ActiveRecord::Migration[4.2]
  def change
    create_table :recordings do |t|
      t.integer :radio_id
      t.integer :dj_id
      t.integer :show_id

      t.timestamps
    end
  end
end
