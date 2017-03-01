class AddTuneInIntegrationColumnsToRadio < ActiveRecord::Migration[4.2]
  def change
    add_column :radios, :tunein_partner_id, :string
    add_column :radios, :tunein_partner_key, :string
    add_column :radios, :tunein_station_id, :string
    add_column :radios, :tunein_metadata_updates_enabled, :boolean, default: false, null: false
  end
end
