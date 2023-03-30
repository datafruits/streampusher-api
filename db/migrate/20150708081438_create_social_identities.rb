class CreateSocialIdentities < ActiveRecord::Migration[4.2]
  def change
    create_table :social_identities do |t|
      t.string :uid, null: false, default: ""
      t.string :provider, null: false, default: ""
      t.references :user, null: false

      t.string :token
      t.string :token_secret
      t.string :name, null: false, default: ""

      t.timestamps null: false
    end
  end
end
