class Recording < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
  # belongs_to :show
  enum processing_status: ['unprocessed', 'processing', 'processed']

  default_scope { order(created_at: :desc) }
end
