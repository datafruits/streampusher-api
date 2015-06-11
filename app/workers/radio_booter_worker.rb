require 'uri'
require_relative '../../lib/docker_wrapper'
require_relative '../../lib/ufw'

class RadioBooterWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    if ::Rails.env.development?
      redis = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname
    else
      redis = Redis.new
    end

    icecast_container = DockerWrapper.find_or_create 'mcfiredrill/icecast:latest', "#{radio_name}_icecast"
    radio.update icecast_container_id: icecast_container.id
    #if ::Rails.env.production?
    #  port = icecast_container.host_port(8000)
    #  if port
    #    UFW.close_port port
    #  end
    #end
    icecast_container.stop
    icecast_container.start
    redis.hset 'proxy-domain', "#{radio.virtual_host}/icecast", icecast_container.host_port(8000)
    # if ::Rails.env.production?
    #   port = icecast_container.host_port(8000)
    #   if port
    #     UFW.open_port port
    #   end
    # end

    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap:latest',
      "#{radio_name}_liquidsoap",
      ["RADIO_NAME=#{radio_name}","RAILS_ENV=#{Rails.env}"],
      ["#{radio_name}_icecast:icecast","streampusher_redis_1:redis"],
      ["#{radio.tracks_directory}:/home/liquidsoap/tracks"]
    radio.update liquidsoap_container_id: liquidsoap_container.id
    #if ::Rails.env.production?
    #  port = liquidsoap_container.host_port(9000)
    #  if port
    #    UFW.close_port port
    #  end
    #end
    liquidsoap_container.stop
    liquidsoap_container.start
    redis.hset 'proxy-domain', "#{radio.virtual_host}/liquidsoap", liquidsoap_container.host_port(9000)
    #if ::Rails.env.production?
    #  port = liquidsoap_container.host_port(9000)
    #  if port
    #    UFW.open_port port
    #  end
    #end
    radio.playlists.each do |playlist|
      SavePlaylistToRedisWorker.perform_later playlist.id
    end
  end
end
