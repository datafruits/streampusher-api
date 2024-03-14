class CreateShrimpoVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :shrimpo_votes do |t|
      t.references :shrimpo_voting_category, null: false, index: true
      t.references :shrimpo_entry, null: false, index: true
      t.references :user, null: false, index: true

      t.integer :score, null: false

      t.timestamps
    end
  end
end
