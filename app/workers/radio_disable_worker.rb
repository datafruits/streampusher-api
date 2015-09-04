require_relative '../../lib/docker_wrapper'

class RadioDisableWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    radio = Radio.find radio_id
    radio_name = radio.name
    icecast_container = DockerWrapper.find_or_create 'mcfiredrill/icecast:latest', "#{radio_name}_icecast"
    icecast_container.stop
    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap:latest', "#{radio_name}_liquidsoap"
    liquidsoap_container.stop
    radio.update enabled: false
  end
end
