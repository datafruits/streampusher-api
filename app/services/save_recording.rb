require 'rubygems/package'

class SaveRecording
  def self.save filename, radio_name
    radio = Radio.find_by_name! radio_name
    file = download_file filename, radio
    user = extract_username_from_filename filename
    Recording.create! file: file, dj: user, radio: radio
  end

  private
  def self.download_file filename, radio
    container = radio.liquidsoap_container
    temp_tar_file = Tempfile.new "tar"
    temp_tar_file.binmode
    begin
      container.copy(filename){ |chunk| temp_tar_file.write(chunk) }

      # untar file and write it to a new file
      temp_tar_file.rewind
      tar = Gem::Package::TarReader.new temp_tar_file
      tar.each do |entry|
        if entry.file?
          temp_untarred_file = Tempfile.new([File.basename(entry.full_name, ".*"), ".mp3"])
          temp_untarred_file.binmode
          temp_untarred_file.write(entry.read)
          temp_untarred_file.chmod(entry.header.mode)
          return temp_untarred_file
        end
      end

    ensure
      temp_tar_file.close
      temp_tar_file.unlink
    end
  end

  def self.extract_username_from_filename filename
  end
end
