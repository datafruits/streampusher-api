class PayoutFruitTicketTrackPlaysWorker < ActiveJob::Base
  queue_as :default

  def perform
    Redis.current.hgetall("datafruits:track_plays").each do |track_id, count|
      track = Track.find track_id
      if track
        user = track.scheduled_show.performers.first
        if user
          fruit_ticket_transaction = FruitTicketTransaction.new to_user: user, amount: count, transaction_type: :archive_playback, source_id: track.id
          fruit_ticket_transaction.transact_and_save!
        end
      end
    end

    Redis.current.del "datafruits:track_plays"
  end
end
