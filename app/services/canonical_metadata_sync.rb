class CanonicalMetadataSync
  def self.perform radio_id, metadata
    radio = Radio.find radio_id
    canonical_metadata = {}
    canonical_metadata["title"] = metadata.strip
    liq = LiquidsoapRequests.new radio_id
    current_source = liq.current_source
    canonical_metadata["current_source"] = current_source
    if(["live_dj", "scheduled_shows"].include?(current_source))
      current_show = Radio.first.current_scheduled_show
      if current_show
        canonical_metadata["show_series_id"] = current_show.show_series.slug
        canonical_metadata["episode_id"] = current_show.slug
      else
        # be sure to clear out old data
        canonical_metadata["show_series_id"] = ""
        canonical_metadata["episode_id"] = ""
      end
    else
      # grab from archive metadata
      canonical_metadata["show_series_id"] = StreamPusher.redis.hget "#{radio.name}:current_archive", "show_series"
      canonical_metadata["episode_id"] = StreamPusher.redis.hget "#{radio.name}:current_archive", "episode"
    end
    # { current_source: "live", title: "LIVE -- oven", show_series_id: "fruits-2nite", episode_id: "fruits-2nite-12312023", dj: "oven" }
    # { current_source: "scheduled_shows", title: "DHL - 09272025", show_series_id: "digital-high-life", episode_id: "digital-high-life-08282025", dj: "mitsuco" }
    # { current_source: "backup_playlist", title: "DHL - 09272025", show_series_id: "digital-high-life", episode_id: "digital-high-life-08282025", dj: "mitsuco" }
    # set canonical metadata
    StreamPusher.redis.hset "#{radio.name}:canonical_metadata", canonical_metadata
  end
end
