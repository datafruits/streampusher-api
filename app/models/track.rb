class Track < ActiveRecord::Base
  belongs_to :radio
  mount_uploader :audio_file_name, TrackUploader
end
