class ChangeRadioIdColumnOnRecordings < ActiveRecord::Migration[4.2]
  def change
    change_column_null :recordings, :radio_id, false
  end
end
