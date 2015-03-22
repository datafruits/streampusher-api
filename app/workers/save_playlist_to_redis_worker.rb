class SavePlaylistToRedisWorker < ActiveJob::Base
  queue_as :default

  def perform playlist_id
    playlist = Playlist.find playlist_id
    if ::Rails.env.development?
      redis = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname
    else
      redis = Redis.new
    end
    redis.del playlist.redis_key
    playlist.playlist_tracks.rank(:position).reverse.each do |playlist_track|
      track = Track.find(playlist_track.track_id)
      redis.rpush playlist.redis_key, track.file_basename
    end
  end
end
