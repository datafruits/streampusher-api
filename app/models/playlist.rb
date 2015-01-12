class Playlist < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks
  has_many :tracks, through: :playlist_tracks
  after_save :persist_to_redis

  def redis_key
    "#{self.radio.name}:playlist"
  end

  private
  def persist_to_redis
    SavePlaylistToRedisWorker.perform_async self.id
  end
end
