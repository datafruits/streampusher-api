class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    container = Docker::Container.create( 'Image' => 'mcfiredrill/radio')
    container.start("PublishAllPorts" => "true", "Env"=> {"VIRTUAL_HOST"=>radio.virtual_host})
    radio.update docker_container_id: container.id
  end
end
