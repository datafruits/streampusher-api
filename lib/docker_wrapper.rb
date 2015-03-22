require 'docker'
require 'socket'

class DockerWrapper
  attr_reader :container

  def initialize container
    @container = container
  end

  def self.find_or_create image, name, env=[], links=[], binds=[]
    @links = links
    begin
      container = Docker::Container.get name
      container.stop
      container.remove
      container = Docker::Container.create('Image' => image, 'name' => name, 'Env' => env, 'HostConfig' => { 'Links' => links, 'Binds' => binds } )
    rescue Docker::Error::NotFoundError
      # image is not pulled yet
      Docker::Image.create('fromImage' => image)
      container = Docker::Container.create('Image' => image, 'name' => name, 'Env' => env, 'HostConfig' => { 'Links' => links, 'Binds' => binds } )
    end
    self.new container
  end

  def start
    if ::Rails.env.development?
      @container.start("PublishAllPorts" => "true", 'ExposedPorts' => { "3000/http": [{ "HostPort": "3000" }] },'ExtraHosts' => ["docker:#{local_private_ip}"])
    else
      @container.start("PublishAllPorts" => "true", 'ExtraHosts' => ["docker:#{local_private_ip}"])
    end
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

  def links
    @container.json["HostConfig"]["Links"]
  end

  def id
    @container.id
  end

  private
  def local_private_ip
    # probably portable?
    Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
  end
end
