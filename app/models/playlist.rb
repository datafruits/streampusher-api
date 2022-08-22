class Playlist < ActiveRecord::Base
  include RedisConnection

  belongs_to :radio
  belongs_to :user
  has_many :playlist_tracks, -> { order("position" => "ASC") }
  has_many :tracks, through: :playlist_tracks
  belongs_to :interpolated_playlist, class_name: "Playlist", foreign_key: "interpolated_playlist_id"

  validates :interpolated_playlist_track_play_count, presence: true, if: :interpolated_playlist_enabled?
  validates :interpolated_playlist_track_interval_count, presence: true, if: :interpolated_playlist_enabled?
  validates :interpolated_playlist_id, presence: true, if: :interpolated_playlist_enabled?

  validates :name, presence: true

  after_save :set_default_playlist
  after_save :persist_to_redis
  after_touch :persist_to_redis
  before_destroy :set_most_recently_updated_playlist_to_default

  default_scope { order(updated_at: :desc) }

  def redis_key
    "#{self.radio.name}:playlist:#{name}"
  end

  def add_track track
    self.tracks << track
  end

  def remove_track playlist_track
    playlist_track.destroy
  end

  def pop_next_track
    track_id = redis.rpop redis_key
    return if track_id.blank?
    if self.repeat?
      redis.lpush redis_key, track_id
    end
    track_id
  end

  def redis_length
    return redis.llen redis_key
  end

  def default?
    self.radio.default_playlist_id == self.id
  end

  private
  def persist_to_redis
    SavePlaylistToRedisWorker.perform_later self.id
  end

  def set_default_playlist
    if !self.radio.default_playlist.present?
      self.radio.update default_playlist_id: self.id
    end
  end

  def set_most_recently_updated_playlist_to_default
    if default?
      self.radio.update default_playlist_id: self.radio.playlists.where.not(id: id).first.id
    end
  end
end
