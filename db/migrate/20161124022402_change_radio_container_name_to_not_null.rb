class ChangeRadioContainerNameToNotNull < ActiveRecord::Migration
  def change
    change_column_null :radios, :container_name, false
  end
end
