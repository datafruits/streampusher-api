class MakePodcastRadioIdNullFalse < ActiveRecord::Migration[4.2]
  def change
    change_column_null :podcasts, :radio_id, false
  end
end
