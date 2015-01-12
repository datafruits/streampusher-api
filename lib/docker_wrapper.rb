require 'docker'

class DockerWrapper
  attr_reader :container

  def initialize container
    @container = container
  end

  def self.find_or_create image, name, links=[]
    begin
      container = Docker::Container.get name
    rescue Docker::Error::NotFoundError
      container = Docker::Container.create('Image' => image, 'name' => name, 'Links' => links)
    end
    self.new container
  end

  def start env={}
    @container.start("PublishAllPorts" => "true", "Env"=> env)
  end

  def host_port
    # nice api docker heheh :P
    @container.json["NetworkSettings"]["Ports"]["8000/tcp"].first["HostPort"]
  end

  def id
    @container.id
  end
end
