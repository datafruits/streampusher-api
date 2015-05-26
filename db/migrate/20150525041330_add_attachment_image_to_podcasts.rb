class AddAttachmentImageToPodcasts < ActiveRecord::Migration
  def self.up
    change_table :podcasts do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :podcasts, :image
  end
end
