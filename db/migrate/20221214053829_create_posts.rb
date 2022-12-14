class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, index: true, null: false
      t.references :postable, polymorphic: true, index: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
