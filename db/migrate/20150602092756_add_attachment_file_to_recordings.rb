class AddAttachmentFileToRecordings < ActiveRecord::Migration
  def change
    add_attachment :recordings, :file
  end
end
