class RadioBooter
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name

    if !radio.icecast_container.blank?
      icecast_container = radio.icecast_container
    else
      icecast_container = Docker::Container.create('Image' => 'mcfiredrill/icecast', 'Name' => "#{radio_name}/icecast")
      radio.update icecast_container_id: icecast_container_id.id
    end
    icecast_container.start("PublishAllPorts" => "true")

    if !radio.liquidsoap_container.blank?
      liquidsoap_container = radio.liquidsoap_container
    else
      liquidsoap_container = Docker::Container.create('Image' => 'mcfiredrill/liquidsoap', 'Name' => "#{radio_name}/liquidsoap",
                                                      "Domainname"=> radio.virtual_host, 'Links' => ["#{radio_name}/icecast:icecast","redis:redis"])
      radio.update liquidsoap_container_id: liquidsoap_container.id
    end
    liquidsoap_container.start("PublishAllPorts" => "true", "Env"=> {"RADIO_NAME"=>radio_name})
  end
end
