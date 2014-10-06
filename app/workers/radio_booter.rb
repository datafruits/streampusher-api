class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    container = Docker::Container.create( 'Image' => 'mcfiredrill/radio', "Env"=> ["VIRTUAL_HOST=#{radio.virtual_host}"])
    container.start("PublishAllPorts" => "true")
    radio.update docker_container_id: container.id
  end
end
