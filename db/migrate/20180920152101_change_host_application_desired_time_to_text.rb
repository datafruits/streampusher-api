class ChangeHostApplicationDesiredTimeToText < ActiveRecord::Migration[5.0]
  def change
    change_column :host_applications, :desired_time, :text, null: false
  end
end
