class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    icecast_container = Docker::Container.create('Image' => 'mcfiredrill/icecast', 'Name' => "#{radio_name}/icecast")
    icecast_container.start("PublishAllPorts" => "true")
    liquidsoap_container = Docker::Container.create('Image' => 'mcfiredrill/liquidsoap', 'Name' => "#{radio_name}/liquidsoap",
                                                    "Domainname"=> radio.virtual_host, 'Links' => ["#{radio_name}/icecast:icecast"])
    liquidsoap_container.start("PublishAllPorts" => "true", "Env"=> {"RADIO_NAME"=>radio_name})
    radio.update icecast_container_id: icecast_container_id.id
    radio.update liquidsoap_container_id: liquidsoap_container.id
  end
end
