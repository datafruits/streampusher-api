require 'uri'
require_relative '../../lib/docker_wrapper'

class RadioBooterWorker
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    redis = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname

    icecast_container = DockerWrapper.find_or_create 'mcfiredrill/icecast', "#{radio_name}_icecast"
    radio.update icecast_container_id: icecast_container.id
    icecast_container.start
    redis.hset 'proxy-domain', radio.virtual_host, icecast_container.host_port

    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap', "#{radio_name}_liquidsoap", ["#{radio_name}_icecast:icecast","redis:redis"]
    radio.update liquidsoap_container_id: liquidsoap_container.id
    liquidsoap_container.start "RADIO_NAME"=>radio_name
  end
end
