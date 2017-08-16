class AddAddressAndCountryToListens < ActiveRecord::Migration[5.0]
  def change
    add_column :listens, :country, :string
    add_column :listens, :address, :string
  end
end
