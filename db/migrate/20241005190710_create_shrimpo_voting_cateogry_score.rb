class CreateShrimpoVotingCateogryScore < ActiveRecord::Migration[7.0]
  def change
    create_table :shrimpo_voting_cateogry_scores do |t|
      t.references :shrimpo_entry, null: false, index: { name: 'shrimpo_entry_score' }
      t.references :shrimpo_voting_category, null: false, index:  { name: 'voting_cat_score' }

      t.integer :score
      t.integer :ranking

      t.timestamps
    end
  end
end
