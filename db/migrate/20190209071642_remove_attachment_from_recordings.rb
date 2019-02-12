class RemoveAttachmentFromRecordings < ActiveRecord::Migration[5.0]
  def change
    remove_attachment :recordings, :file
  end
end
