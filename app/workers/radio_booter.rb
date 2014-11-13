class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    container = Docker::Container.create('Image' => 'mcfiredrill/radio', "Domainname"=> radio.virtual_host)
    container.start("PublishAllPorts" => "true", "Env"=> {"RADIO_NAME"=>radio.name})
    radio.update docker_container_id: container.id
  end
end
