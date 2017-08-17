class AddTweetUrlToRadios < ActiveRecord::Migration[5.0]
  def change
    add_column :radios, :show_share_url, :string
  end
end
