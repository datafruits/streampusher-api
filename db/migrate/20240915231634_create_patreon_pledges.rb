class CreatePatreonPledges < ActiveRecord::Migration[7.0]
  def change
    create_table :patreon_pledges do |t|
      t.string :json_blob
      t.string :name
      t.integer :pledge_amount_cents

      t.timestamps
    end
  end
end
