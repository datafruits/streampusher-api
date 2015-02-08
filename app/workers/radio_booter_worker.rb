require 'uri'
require_relative '../../lib/docker_wrapper'

class RadioBooterWorker
  include Sidekiq::Worker

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    redis = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname

    icecast_container = DockerWrapper.find_or_create 'mcfiredrill/icecast:latest', "#{radio_name}_icecast"
    radio.update icecast_container_id: icecast_container.id
    icecast_container.stop
    icecast_container.start
    redis.hset 'proxy-domain', "#{radio.virtual_host}/icecast", icecast_container.host_port(8000)

    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap:latest', "#{radio_name}_liquidsoap", ["RADIO_NAME=#{radio_name}","RAILS_ENV=#{Rails.env}"], ["#{radio_name}_icecast:icecast","streampusher_redis_1:redis"]
    radio.update liquidsoap_container_id: liquidsoap_container.id
    liquidsoap_container.stop
    liquidsoap_container.start
    redis.hset 'proxy-domain', "#{radio.virtual_host}/liquidsoap", liquidsoap_container.host_port(9000)
    radio.playlists.each do |playlist|
      SavePlaylistToRedisWorker.perform_async playlist.id
    end
  end
end
