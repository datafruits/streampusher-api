class AddEndedAtToShrimpo < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :ended_at, :datetime
  end
end
