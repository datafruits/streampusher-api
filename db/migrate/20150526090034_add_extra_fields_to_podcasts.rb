class AddExtraFieldsToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :extra_tags, :string
  end
end
