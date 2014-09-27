class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    container = Docker::Container.create( 'Image' => 'mcfiredrill/radio', 'ExposedPorts' => ["8000/tcp"] )
    container.start("PortBindings" => { "8000/tcp" => ["HostPort"=>8000 ] })
    radio = Radio.find radio_id
    radio.update docker_container_id: container.id
  end
end
