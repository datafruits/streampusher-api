class ChangeRadioIdColumnOnRecordings < ActiveRecord::Migration
  def change
    change_column_null :recordings, :radio_id, false
  end
end
