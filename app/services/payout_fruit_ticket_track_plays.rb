class PayoutFruitTicketTrackPlays
  include RedisConnection

  def perform
    redis.hgetall("datafruits:track_plays").each do |track_id, count|
      track = Track.find track_id
      if track && track.scheduled_show
        user = track.scheduled_show.performers.first
        if user
          # TODO check this transaction didn't already happen for this month
          # ...or day>?????
          fruit_ticket_transaction = FruitTicketTransaction.new to_user: user, amount: count, transaction_type: :archive_playback, source_id: track.id
          fruit_ticket_transaction.transact_and_save!
          redis.hdel "datafruits:track_plays", track_id
        end
      else
        raise "couldn't find track with id: #{track_id} in PayoutFruitTicketTrackPlays"
      end
    end

    redis.del "datafruits:track_plays"
  end
end
