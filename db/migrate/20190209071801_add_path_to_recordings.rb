class AddPathToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_column :recordings, :path, :string
  end
end
