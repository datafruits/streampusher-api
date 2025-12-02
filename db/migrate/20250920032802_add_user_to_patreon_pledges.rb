class AddUserToPatreonPledges < ActiveRecord::Migration[7.0]
  def change
    add_column :patreon_pledges, :user_id, :integer
  end
end
