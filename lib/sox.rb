require 'cocaine'

class Sox
  def self.merge new_filename, *merged_files
    line = Cocaine::CommandLine.new("sox", ":merged_files :new_filename")
    line.run(merged_files: merged_files, new_filename: new_filename)
  end

  def self.trim path
    new_path = "#{File.dirname(path)}/#{File.basename(path, ".mp3")}_trimmed.mp3"
    line = Cocaine::CommandLine.new("sox", ":path :new_path silence -l  1 1.0 1% -1 5.0 1%")
    line.run(path: path, new_path: new_path)
    new_path
  end
end
