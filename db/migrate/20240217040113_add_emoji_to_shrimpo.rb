class AddEmojiToShrimpo < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :emoji, :string
  end
end
