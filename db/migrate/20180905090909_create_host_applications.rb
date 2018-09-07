class CreateHostApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :host_applications do |t|
      t.references :radio, null: false, index: true
      t.string :email, null: false
      t.string :username, null: false
      t.string :link, null: false
      t.integer :interval, null: false, default: 0

      t.timestamp :desired_time, null: false

      t.string :time_zone, null: false

      t.string :other_comment

      t.timestamps
    end
  end
end
