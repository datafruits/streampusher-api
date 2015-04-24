class AddNameToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :name, :string, null: false, default: ''
  end
end
