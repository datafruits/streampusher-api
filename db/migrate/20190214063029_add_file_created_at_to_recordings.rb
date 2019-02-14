class AddFileCreatedAtToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_column :recordings, :file_created_at, :datetime

    Recording.where.not(path: nil).find_each do |recording|
      recording.update file_created_at: File.ctime(recording.path)
    end
  end
end
