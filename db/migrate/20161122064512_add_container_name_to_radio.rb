class AddContainerNameToRadio < ActiveRecord::Migration
  def change
    add_column :radios, :container_name, :string

    Radio.find_each do |radio|
      radio.update_column :container_name, radio.name
    end
  end
end
