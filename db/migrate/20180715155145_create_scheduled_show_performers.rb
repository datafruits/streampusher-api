class CreateScheduledShowPerformers < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduled_show_performers do |t|
      t.references :user
      t.references :scheduled_show

      t.timestamps
    end
  end
end
