require 'uri'
require_relative '../../lib/docker_wrapper'
require_relative '../../lib/ufw'

class RadioBooterWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    redis = Redis.current

    icecast_container = DockerWrapper.find_or_create 'mcfiredrill/icecast:latest', "#{radio_name}_icecast"
    radio.update icecast_container_id: icecast_container.id
    if ::Rails.env.production?
     port = redis.hget "proxy-domain", radio.icecast_proxy_key
     if port.present?
       UFW.close_port port
     end
    end
    icecast_container.stop
    icecast_container.start
    redis.hset 'proxy-domain', radio.icecast_proxy_key, icecast_container.host_port(8000)
    if ::Rails.env.production?
      port = icecast_container.host_port(8000)
      if port.present?
        UFW.open_port port
      end
    end

    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap:latest',
      "#{radio_name}_liquidsoap",
      ["RADIO_NAME=#{radio_name}","RAILS_ENV=#{Rails.env}"],
      ["#{radio_name}_icecast:icecast","streampusher_redis_1:redis"],
      ["#{radio.tracks_directory}:/home/liquidsoap/tracks"]
    radio.update liquidsoap_container_id: liquidsoap_container.id
    if ::Rails.env.production?
     port = redis.hget "proxy-domain", radio.liquidsoap_proxy_key
     if port.present?
       UFW.close_port port
     end
    end
    liquidsoap_container.stop
    liquidsoap_container.start
    redis.hset 'proxy-domain', radio.liquidsoap_proxy_key, liquidsoap_container.host_port(9000)
    if ::Rails.env.production?
     port = liquidsoap_container.host_port(9000)
     if port.present?
       UFW.open_port port
     end
    end
    radio.update enabled: true
    radio.playlists.each do |playlist|
      SavePlaylistToRedisWorker.perform_later playlist.id
    end
    SaveRadioSettingsToRedisWorker.perform_later radio.id
  end
end
