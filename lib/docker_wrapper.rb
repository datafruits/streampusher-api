require 'docker'

class DockerWrapper
  attr_reader :container

  def initialize container
    @container = container
  end

  def self.find_or_create image, name, env=[], links=[]
    begin
      container = Docker::Container.get name
    rescue Docker::Error::NotFoundError
      container = Docker::Container.create('Image' => image, 'name' => name, 'Env' => env, 'HostConfig' => { 'Links' => links })
    end
    self.new container
  end

  def start
    @container.start("PublishAllPorts" => "true")
  end

  def stop
    @container.stop
  end

  def host_port
    # nice api docker heheh :P
    @container.json["NetworkSettings"]["Ports"]["8000/tcp"].first["HostPort"]
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
end
