class Playlist < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks, -> { order("podcast_published_date" => "DESC") }
  has_many :tracks, through: :playlist_tracks
  has_one :interpolated_playlist, class_name: "Playlist", foreign_key: "interpolated_playlist_id"

  validates :interpolated_playlist_track_play_count, presence: true, if: :interpolated_playlist_present?
  validates :interpolated_playlist_track_interval_count, presence: true, if: :interpolated_playlist_present?

  after_save :set_default_playlist

  def redis_key
    "#{self.radio.name}:playlist:#{name}"
  end

  def add_track track
    self.tracks << track
  end

  def remove_track playlist_track
    playlist_track.destroy
  end

  private
  def interpolated_playlist_present?
    self.interpolated_playlist.present?
  end

  def set_default_playlist
    if !self.radio.default_playlist.present?
      self.radio.update default_playlist_id: self.id
    end
  end
end
