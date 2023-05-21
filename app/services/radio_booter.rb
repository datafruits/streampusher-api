require 'uri'

class RadioBooter
  def self.boot radio
    radio_name = radio.container_name
    redis = StreamPusher.redis

    image = radio.docker_image_name.present? ? radio.docker_image_name : 'mcfiredrill/liquidsoap:latest'
    name = "#{radio_name}_liquidsoap"
    env = ["RADIO_NAME=#{radio_name}","RAILS_ENV=#{Rails.env}",
       "ICECAST_HOST", "icecast",
       "TUNEIN_PARTNER_ID=#{radio.tunein_partner_id}",
       "TUNEIN_PARTNER_KEY=#{radio.tunein_partner_key}",
       "TUNEIN_METADATA_UPDATES_ENABLED=#{radio.tunein_metadata_updates_enabled?}",
       "TUNEIN_STATION_ID=#{radio.tunein_station_id}",
       "LIQ_SECRET=#{Rails.application.secrets.liq_secret}",
       "STEREO_TOOL_KEY=#{Rails.application.secrets.stereo_tool_key}"]
    binds = ["#{radio.tracks_directory}:/home/liquidsoap/tracks",
       "#{radio.recordings_directory}:/home/liquidsoap/recordings",
       "#{radio.hls_directory}:/home/liquidsoap/hls"]
    host_ports = {}

    if radio.port_number
      host_ports['9000'] = radio.port_number
    end

    liquidsoap_container = DockerWrapper.find_or_create image,
      name,
      env,
      binds,
      host_ports

    if ::Rails.env.production?
     port = redis.hget "proxy-domain", radio.liquidsoap_proxy_key
     if port.present?
       UFW.close_port port
     end
    end
    liquidsoap_container.stop
    liquidsoap_container.start

    host_port = liquidsoap_container.host_port(9000)

    radio.update liquidsoap_container_id: liquidsoap_container.id,
      port_number: host_port

    radio.set_current_show_playing nil

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
