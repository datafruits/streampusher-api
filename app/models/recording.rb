class Recording < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
  belongs_to :track
  attr_accessor :file
  # belongs_to :show
  enum processing_status: ['unprocessed', 'processing', 'processed', 'processing_failed']
  default_scope { order(created_at: :desc) }

  def filesize
    if File.exists? self.file
      (File.size(self.file).to_f)
    else
      "???"
    end
  end
end
