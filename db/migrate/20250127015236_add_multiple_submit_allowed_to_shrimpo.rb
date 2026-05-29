class AddMultipleSubmitAllowedToShrimpo < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :multi_submit_allowed, :boolean, null: false, default: false
  end
end
