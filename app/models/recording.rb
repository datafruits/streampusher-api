class Recording < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
  belongs_to :track

  # Ensure one-to-one relationship between recording and track
  validates :track_id, uniqueness: true, allow_nil: true

  enum processing_status: ['unprocessed', 'processing', 'processed', 'processing_failed']

  default_scope { order(created_at: :desc) }

  def filesize
    if File.exist? self.path
      (File.size(self.path).to_f / 2**20).round(2)
    else
      "???"
    end
  end
end
