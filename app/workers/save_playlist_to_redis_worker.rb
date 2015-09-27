class SavePlaylistToRedisWorker < ActiveJob::Base
  queue_as :default

  def perform playlist_id
    playlist = Playlist.find playlist_id
    PersistPlaylistToRedis.perform playlist
  end
end
