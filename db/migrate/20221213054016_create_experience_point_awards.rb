class CreateExperiencePointAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :experience_point_awards do |t|
      t.references :user, index: true
      t.integer :amount, null: false
      t.integer :award_type, null: false
      t.integer :source_id

      t.timestamps
    end
  end
end
