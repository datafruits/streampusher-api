require 'docker'
require 'socket'

class DockerWrapper
  attr_reader :container

  def initialize container
    @container = container
  end

  def self.find_or_create image, name, env=[], binds=[], host_ports={}
    begin
    container = Docker::Container.get name
    container.stop
    container.remove
    rescue Docker::Error::NotFoundError
      # container doesn't exist, so take no action
    end
    begin
      container = Docker::Container.create('Image' => image, 'name' => name, 'Env' => env, 'HostConfig' => host_config(binds, host_ports))
    rescue Docker::Error::NotFoundError
      # image is not pulled yet
      Docker::Image.create('fromImage' => image)
      container = Docker::Container.create('Image' => image, 'name' => name, 'Env' => env, 'HostConfig' => host_config(binds, host_ports))
    end
    self.new container
  end

  def start
    @container.start
  end

  def stop
    @container.stop
  end

  def host_port port
    # nice api docker heheh :P
    ports = @container.json["NetworkSettings"].fetch("Ports")
    if ports
      ports.fetch("#{port}/tcp").try(:first).fetch("HostPort")
    end
  end

  def env
    @container.json["Config"]["Env"]
  end

  def id
    @container.id
  end

  private

  def self.host_config binds, host_ports
    conf = {
      'Binds' => binds,
      'ExtraHosts' => ["docker:#{local_private_ip}"],
      "PublishAllPorts" => true,
      "NetworkMode" => network_mode,
    }
    if host_ports.any?
      port_bindings = {}
      host_ports.each do |container_port, host_port|
        port_bindings["#{container_port}/tcp" => [{'HostPort' => "#{host_port}"}]]
      end
      conf["PortBindings"] = port_bindings
    end
  end

  def self.network_mode
    "streampusher_default"
  end

  def self.local_private_ip
    # probably portable?
    Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
  end
end
