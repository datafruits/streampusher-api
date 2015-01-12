class SavePlaylistToRedisWorker
  include Sidekiq::Worker

  def perform playlist_id
    playlist = Playlist.find playlist_id
    redis = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname
    redis.del playlist.redis_key
    playlist.tracks.each do |track|
      redis.rpush playlist.redis_key track.audio_file_name
    end
  end
end
