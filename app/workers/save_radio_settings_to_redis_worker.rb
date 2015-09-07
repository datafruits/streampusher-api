class SaveRadioSettingsToRedisWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    radio = Radio.find radio_id
    redis = Redis.current
    if radio.default_playlist.present?
      redis.set radio.default_playlist_key, radio.default_playlist.redis_key
    end
  end
end
