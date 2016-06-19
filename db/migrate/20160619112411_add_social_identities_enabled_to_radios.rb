class AddSocialIdentitiesEnabledToRadios < ActiveRecord::Migration
  def change
    add_column :radios, :social_identities_enabled, :boolean, default: false, null: false
  end
end
