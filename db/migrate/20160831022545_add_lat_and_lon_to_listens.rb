class AddLatAndLonToListens < ActiveRecord::Migration[4.2]
  def change
    add_column :listens, :lat, :float
    add_column :listens, :lon, :float
  end
end
