require 'cocaine'

class UFW
  def self.open_port port
    line = Cocaine::CommandLine.new("ufw", "allow :port")
    line.run(port: port)
  end

  def self.close_port port
    line = Cocaine::CommandLine.new("ufw", "deny :port")
    line.run(port: port)
  end
end
