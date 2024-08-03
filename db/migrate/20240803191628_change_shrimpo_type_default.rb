class ChangeShrimpoTypeDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :shrimpos, :shrimpo_type, 0
  end
end
