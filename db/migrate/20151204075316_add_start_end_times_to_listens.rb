class AddStartEndTimesToListens < ActiveRecord::Migration
  def change
    add_column :listens, :start_at, :datetime
    add_column :listens, :end_at, :datetime
  end
end
