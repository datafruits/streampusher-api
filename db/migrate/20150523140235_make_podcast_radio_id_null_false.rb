class MakePodcastRadioIdNullFalse < ActiveRecord::Migration
  def change
    change_column_null :podcasts, :radio_id, false
  end
end
