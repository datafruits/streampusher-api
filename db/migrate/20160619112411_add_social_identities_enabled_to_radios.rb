class AddSocialIdentitiesEnabledToRadios < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :social_identities_enabled, :boolean, default: false, null: false
  end
end
