require 'uri'
require_relative '../../lib/docker_wrapper'
require_relative '../../lib/ufw'

class RadioBooter
  def self.boot radio
    radio_name = radio.container_name
    redis = Redis.current

    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap:latest',
      "#{radio_name}_liquidsoap",
      ["RADIO_NAME=#{radio_name}","RAILS_ENV=#{Rails.env}",
       "ICECAST_HOST", "icecast",
       "TUNEIN_PARTNER_ID=#{radio.tunein_partner_id}", "TUNEIN_PARTNER_KEY=#{radio.tunein_partner_key}",
       "TUNEIN_METADATA_UPDATES_ENABLED=#{radio.tunein_metadata_updates_enabled?}",
       "TUNEIN_STATION_ID=#{radio.tunein_station_id}"],
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
