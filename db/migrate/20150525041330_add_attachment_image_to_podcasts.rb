class AddAttachmentImageToPodcasts < ActiveRecord::Migration[4.2]
  def self.up
    change_table :podcasts do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :podcasts, :image
  end
end
