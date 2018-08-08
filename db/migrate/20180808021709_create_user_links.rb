class CreateUserLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url
      t.references :user, null: false

      t.timestamps
    end
  end
end
