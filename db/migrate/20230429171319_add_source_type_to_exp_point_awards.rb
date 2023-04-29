class AddSourceTypeToExpPointAwards < ActiveRecord::Migration[6.1]
  def change
    add_column :experience_point_awards, :source_type, :string
  end
end
