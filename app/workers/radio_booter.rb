class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    container = Docker::Container.create( 'Image' => 'mcfiredrill/radio')
    container.start("PublishAllPorts" => "true")
    radio = Radio.find radio_id
    radio.update docker_container_id: container.id
  end
end
