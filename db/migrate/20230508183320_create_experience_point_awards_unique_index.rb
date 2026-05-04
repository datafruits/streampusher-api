class CreateExperiencePointAwardsUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :experience_point_awards, [:source_id, :award_type, :user_id], unique: true, name: "index_xp_awards_on_sid_award_type_uid"
  end
end
