require 'cocaine'

class Sox
  def self.merge new_filename, *merged_files
    line = Cocaine::CommandLine.new("sox", ":merged_files :new_filename")
    line.run(merged_files: merged_files, new_filename: new_filename)
  end
end
