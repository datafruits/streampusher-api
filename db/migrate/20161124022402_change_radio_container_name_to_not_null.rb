class ChangeRadioContainerNameToNotNull < ActiveRecord::Migration[4.2]
  def change
    change_column_null :radios, :container_name, false
  end
end
