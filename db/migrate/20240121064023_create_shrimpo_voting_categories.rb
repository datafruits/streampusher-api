class CreateShrimpoVotingCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :shrimpo_voting_categories do |t|
      t.references :shrimpo, null: false, index: true

      t.string :name
      t.string :emoji

      t.timestamps
    end
  end
end
