class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.references :radio
      t.string :title
      t.string :link
      t.string :description
      t.datetime :last_build_date
      t.string :itunes_summary
      t.string :itunes_name
      t.string :itunes_email

      t.timestamps
    end
  end
end
