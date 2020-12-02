class CreateHostApplicationVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :host_application_votes do |t|
      t.references :host_application, null: false, index: true
      t.references :user, null: false, index: true
      t.boolean :approve, null: false

      t.timestamps
    end
  end
end
