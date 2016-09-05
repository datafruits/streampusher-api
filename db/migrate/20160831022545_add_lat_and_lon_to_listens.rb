class AddLatAndLonToListens < ActiveRecord::Migration
  def change
    add_column :listens, :lat, :float
    add_column :listens, :lon, :float
  end
end
