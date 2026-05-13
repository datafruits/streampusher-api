class CreateUserLiveBars < ActiveRecord::Migration[7.0]
  def change
    create_table :user_live_bars do |t|
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
