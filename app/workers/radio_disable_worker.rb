class RadioDisableWorker < ActiveJob::Base
  queue_as :default

  def perform radio
    radio_name = radio.container_name
    liquidsoap_container = DockerWrapper.find_or_create 'mcfiredrill/liquidsoap:latest', "#{radio_name}_liquidsoap"
    liquidsoap_container.stop
    radio.update enabled: false
  end
end
