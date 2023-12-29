class MetadataPublisher
  def self.perform radio, metadata
    StreamPusher.redis.set "#{radio}:metadata", metadata
    StreamPusher.redis.publish "#{radio}:metadata", metadata
    track = Track.where(title: metadata)
    if track.present?
      if track.scheduled_show
        url = "/shows/#{show_series.slug}/episodes/#{track.scheduled_show.slug}"
        StreamPusher.redis.set "#{radio}:metadata:url", url
        StreamPusher.redis.publish "#{radio}:metadata:url", url
      end
    elsif metadata.starts_with? "LIVE"
      show = radio.current_scheduled_show
      if show.present?
        show_series = show.show_series
        url = "/shows/#{show_series.slug}/episodes/#{show.slug}"
        StreamPusher.redis.set "#{radio}:metadata:url", url
        StreamPusher.redis.publish "#{radio}:metadata:url", url
      end
    end
  end
end
