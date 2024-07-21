class AddShrimpoTypeToShrimpos < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :shrimpo_type, :string
  end
end
