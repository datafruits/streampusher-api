class PayoutFruitTicketTrackPlaysWorker < ActiveJob::Base
  queue_as :default

  def perform
    PayoutFruitTicketTrackPlays.new.perform
  end
end
