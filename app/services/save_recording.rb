require 'rubygems/package'

class SaveRecording
  def self.save filename, radio_name
    radio = Radio.find_by_name! radio_name
    file = File.join(radio.tracks_directory, File.basename(filename))
    user = User.find_by_username extract_username_from_filename(filename, radio.name)
    Recording.create! file: File.new(file), dj: user, radio: radio
  end

  private
  def self.extract_username_from_filename filename, radioname
    File.basename(filename).match(/^#{radioname}-LIVE -- (\S+) - (\S+) (\S+)$/)[1]
  end
end
