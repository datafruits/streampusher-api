class PersistPlaylistToRedis
  def self.perform playlist
    redis = Redis.current
    redis.del playlist.redis_key
    count = 0
    interpolated_playlist_count = 0
    playlist.playlist_tracks.rank(:position).reverse.each do |playlist_track|
      track = Track.find(playlist_track.track_id)
      redis.rpush playlist.redis_key, track.file_basename
      if playlist.interpolated_playlist_enabled?
        if count % playlist.interpolated_playlist_track_interval_count == 0
          track = Track.find(playlist.interpolated_playlist.playlist_tracks.rank(:position).reverse[interpolated_playlist_count].track_id)
          redis.rpush playlist.redis_key, track.file_basename
          interpolated_playlist_count += 1
          if interpolated_playlist_count >= playlist.interpolated_playlist.playlist_tracks.length
            interpolated_playlist_count = 0
          end
        end
      end
      count += 1
    end
  end
end
