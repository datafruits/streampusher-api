class CreateTrophyAwards < ActiveRecord::Migration[7.0]
  def change
    create_table :trophy_awards do |t|
      t.references :user, null: false, index: true
      t.references :trophy, null: false, index: true
      t.references :shrimpo_entry, null: false, index: true

      t.timestamps
    end
  end
end
