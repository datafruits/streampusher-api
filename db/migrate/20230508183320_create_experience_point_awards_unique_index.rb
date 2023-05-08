class CreateExperiencePointAwardsUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :experience_point_awards, [:source_id, :award_type], unique: true
  end
end
