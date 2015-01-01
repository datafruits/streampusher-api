require 'uri'

class RadioBooterWorker
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    redis = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname

    if !radio.icecast_container.blank?
      icecast_container = radio.icecast_container
    else
      icecast_container = Docker::Container.create('Image' => 'mcfiredrill/icecast', 'name' => "#{radio_name}_icecast")
      radio.update icecast_container_id: icecast_container.id
    end
    icecast_container.start("PublishAllPorts" => "true", )
    redis.hset 'proxy-domain', radio.virtual_host, host_port(icecast_container)

    if !radio.liquidsoap_container.blank?
      liquidsoap_container = radio.liquidsoap_container
    else
      liquidsoap_container = Docker::Container.create('Image' => 'mcfiredrill/liquidsoap', 'name' => "#{radio_name}_liquidsoap",
                                                      "Domainname"=> radio.virtual_host, 'Links' => ["#{radio_name}_icecast:icecast","redis:redis"])
      radio.update liquidsoap_container_id: liquidsoap_container.id
    end
    liquidsoap_container.start("PublishAllPorts" => "true", "Env"=> {"RADIO_NAME"=>radio_name})
    # persist this in redis too? watdo? :\
  end

  private
  def host_port container
    # nice api docker heheh :P
    container.json["NetworkSettings"]["Ports"]["8000/tcp"].first["HostPort"]
  end
end
