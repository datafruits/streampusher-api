class AddExtraFieldsToPodcasts < ActiveRecord::Migration[4.2]
  def change
    add_column :podcasts, :extra_tags, :string
  end
end
