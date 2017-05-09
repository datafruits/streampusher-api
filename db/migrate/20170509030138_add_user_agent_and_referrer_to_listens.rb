class AddUserAgentAndReferrerToListens < ActiveRecord::Migration[5.0]
  def change
    add_column :listens, :user_agent, :string
    add_column :listens, :referer, :string
  end
end
