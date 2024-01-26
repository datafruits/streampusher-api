class ScheduledShow < ActiveRecord::Base
  # episode
  include RedisConnection

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :radio
  belongs_to :dj, class_name: "User"
  belongs_to :playlist
  belongs_to :show_series
  belongs_to :recurrant_original, class_name: "ScheduledShow"
  belongs_to :recording

  has_attached_file :image,
    styles: { :thumb => "x300", :medium => "x600" },
    path: ":attachment/:style/:basename.:extension",
    validate_media_type: false # TODO comment out for prod ???? idk
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_many :scheduled_show_labels, dependent: :destroy
  has_many :labels, through: :scheduled_show_labels

  has_many :tracks
  has_many :scheduled_show_performers, class_name: "::ScheduledShowPerformer", dependent: :destroy
  has_many :performers, through: :scheduled_show_performers, source: :user
  accepts_nested_attributes_for :scheduled_show_performers
  has_many :posts, as: :postable

  has_many :scheduled_show_favorites

  scope :future, -> { where("start_at > ?", Time.now) }
  scope :past, -> { where("start_at < ?", Time.now) }

  validates_presence_of :guest, if: -> { is_guest? }
  validates_presence_of :start_at, :end_at, :playlist_id, :title, :dj_id
  validates :description, length: { maximum: 10_000 }

  validate :start_at_cannot_be_in_the_past, on: :create
  validate :end_at_cannot_be_in_the_past, on: :create
  validate :end_at_cannot_be_before_start_at, on: :create

  alias_attribute :start, :start_at
  alias_attribute :end, :end_at
  # attr_accessor :update_all_recurrences, :destroy_recurrences

  # after_create :save_recurrences_in_background_on_create, if: :recurring?
  # after_update :update_recurrences_in_background, if: :recurring_or_recurrence?
  # before_destroy :maybe_destroy_recurrences
  before_destroy :clear_redis_if_playing

  after_update :maybe_process_recording
  after_update :maybe_add_to_default_playlist
  #
  def clear_redis_if_playing
    if self.radio.current_show_playing.to_i == self.id
      self.radio.set_current_show_playing nil
    end
  end

  before_save :ensure_time_zone
  before_save :add_performers

  # enum recurring_interval: [:not_recurring, :day, :week, :month, :year, :biweek]

  enum status: [:archive_unpublished, :archive_published]

  attr_accessor :prerecord_track_id
  attr_accessor :use_prerecorded_file_for_archive

  def use_prerecorded_file_for_archive= y
    if y && self.prerecord_track_id.present?
      track = Track.find self.prerecord_track_id
      self.tracks << track
    end
  end

  def prerecord_track_id
    self.playlist.tracks.first.id if self.playlist.present? && self.playlist.tracks.any? && !(self.playlist.id === self.radio.default_playlist_id)
  end

  def prerecord_track_id= track_id
    if track_id
      self.playlist = self.radio.playlists.create! name: self.slug
      track = Track.find(track_id)
      self.playlist.tracks << track
      if track.title.blank?
        track.title = self.formatted_episode_title
        track.save
      end
    end
  end

  def formatted_episode_title
    "#{self.title} - #{self.start_at.strftime("%m%d%Y")}"
  end

  # TODO
  # validate :time_is_in_15_min_intervals
  #
  #
  def queue_playlist!
    liquidsoap = LiquidsoapRequests.new radio.id
    # should this always happen ?
    playlist = self.playlist || self.show_series.default_playlist
    if playlist.present? && playlist.redis_length < 1 && playlist.tracks.length > 0
      puts "playlist empty in redis for some reason, persisting to redis!"
      PersistPlaylistToRedis.perform self.playlist
    end
    if playlist.present? && playlist.redis_length > 0
      while playlist.redis_length > 0
        track_id = playlist.pop_next_track
        puts "popped next track: #{track_id}"
        if track_id.present?
          track = Track.find track_id
        end
        puts "found track: #{track}"
        if track
          liquidsoap.add_to_queue track.url
          puts "added to queue: #{track.url}"
          ScheduledShowExpAwardWorker.perform_later self.id
        end
      end
    else
      puts "tried to queue #{self.inspect}'s playlist, but playlist empty in redis!"
    end
  end

  def playlist_or_default
    # playlist presence is validated, but it might be deleted
    # and we can't add dependant destroy
    self.playlist || self.radio.default_playlist
  end

  def image_url
    self.image.url(:original)
  end

  def thumb_image_url
    self.image.url(:thumb)
  end

  def schedule_cannot_conflict
    self.radio.scheduled_shows.where.not(id: id).each do |show|
      if end_at > show.start_at && start_at < show.end_at
        errors.add(:time, " conflict detected with show '#{show.user.username} - #{show.title}'. Please choose a different time.")
      end
    end
  end

  def formatted_date
    "#{self.start_at.strftime("%m%d%Y")}"
  end

  def slug_candidates
    [
      [:title, :formatted_date],
      [:title, :formatted_date, :id]
    ]
  end

  def url
    "https://datafruits.fm/shows/#{self.show_series.slug}/episodes/#{self.slug}"
  end

  def maybe_add_to_default_playlist
    if self.archive_published? && self.tracks.any?
      self.tracks.each do |t|
        unless self.radio.default_playlist.tracks.include? t
          self.radio.default_playlist.tracks << t
          Notification.create notification_type: "new_podcast", user: self.performers.first, source: self, send_to_chat: true, send_to_user: false, url: url
        end
      end
    end
  end

  private

  def add_performers
    if self.scheduled_show_performers.empty?
      self.performers << self.dj
    end
  end

  def ensure_time_zone
    unless self.time_zone.blank?
      # only take local times as input
      unless self.start_at.utc?
        self.start_at = ActiveSupport::TimeZone.new(self.time_zone).local_to_utc(self.start_at)
      end
      unless self.end_at.utc?
        self.end_at = ActiveSupport::TimeZone.new(self.time_zone).local_to_utc(self.end_at)
      end
    end
  end

  def start_at_cannot_be_in_the_past
    if start_at < Time.current
      errors.add(:start_at, "cannot be in the past")
    end
  end

  def end_at_cannot_be_in_the_past
    if end_at < Time.current
      errors.add(:end_at, "cannot be in the past")
    end
  end

  def end_at_cannot_be_before_start_at
    if end_at < start_at
      errors.add(:end_at, "cannot be before start at")
    end
  end

  def maybe_process_recording
    if self.recording && self.recording.processing_status === 'unprocessed'
      ProcessRecordingWorker.perform_later self.recording.id, self.id
    end
  end
end
