class CreateListenWorker
  include Sidekiq::Worker

  def perform radio_name, ip_address
    radio = Radio.find_by_name radio_name

    Listen.create radio: radio, ip_address: ip_address
  end
end
