class RadioBooter
  include Sidekiq::Worker

  def perform
    container = Docker::Container.create( 'Image' => 'mcfiredrill/radio', 'ExposedPorts' => ["8000/tcp"] )
    container.start("PortBindings" => { "8000/tcp" => ["HostPort"=>8000 ] })
    container.id
  end
end
