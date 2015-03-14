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
    playlist.tracks.each do |track|
      redis.rpush playlist.redis_key, track.audio_file_name
    end
  end
end
