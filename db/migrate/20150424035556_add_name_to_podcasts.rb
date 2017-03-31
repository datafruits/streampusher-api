class AddNameToPodcasts < ActiveRecord::Migration[4.2]
  def change
    add_column :podcasts, :name, :string, null: false, default: ''
  end
end
