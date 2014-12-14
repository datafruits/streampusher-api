class Track < ActiveRecord::Base
  belongs_to :radio

  def file_basename
    File.basename self.audio_file_name
  end
end
