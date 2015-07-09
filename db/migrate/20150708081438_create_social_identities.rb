class CreateSocialIdentities < ActiveRecord::Migration
  def change
    create_table :social_identities do |t|
      t.string :uid, null: false, default: ""
      t.string :provider, null: false, default: ""
      t.references :user, null: false

      t.string :token, :string
      t.string :token_secret, :string
      t.string :name, null: false, default: ""

      t.timestamps null: false
    end
  end
end
