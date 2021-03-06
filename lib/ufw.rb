require 'cocaine'

class UFW
  def self.open_port port
    line = Cocaine::CommandLine.new("sudo /usr/sbin/ufw", "allow #{port}")
    line.run
  end

  def self.close_port port
    line = Cocaine::CommandLine.new("sudo /usr/sbin/ufw", "delete allow #{port}")
    line.run
  end
end
