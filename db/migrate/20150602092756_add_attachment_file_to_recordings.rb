class AddAttachmentFileToRecordings < ActiveRecord::Migration[4.2]
  def change
    add_attachment :recordings, :file
  end
end
