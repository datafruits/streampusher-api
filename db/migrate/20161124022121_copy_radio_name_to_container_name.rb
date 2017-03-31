class CopyRadioNameToContainerName < ActiveRecord::Migration[4.2]
  def change
    Radio.find_each do |radio|
      if radio.container_name.blank?
        radio.update container_name: radio.name.gsub(/[^a-zA-Z0-9_]/, '')
      end
    end
  end
end
