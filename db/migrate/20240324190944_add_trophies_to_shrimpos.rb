class AddTrophiesToShrimpos < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :gold_trophy_id, :integer, index: true
    add_column :shrimpos, :silver_trophy_id, :integer, index: true
    add_column :shrimpos, :bronze_trophy_id, :integer, index: true
    add_column :shrimpos, :consolation_trophy_id, :integer, index: true
  end
end
