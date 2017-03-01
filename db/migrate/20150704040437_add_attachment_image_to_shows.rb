class AddAttachmentImageToShows < ActiveRecord::Migration[4.2]
  def self.up
    change_table :shows do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :shows, :image
  end
end
