class RadioBooterWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    radio = Radio.find radio_id
    RadioBooter.boot radio
  end
end
