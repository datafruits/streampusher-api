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
    validate_media_type: false # TODO comment out for prod
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

  # def recurrences
  #   self.class.where(recurrant_original_id: self.id)
  # end
  #
  # def recurring?
  #   !self.not_recurring? && !self.recurrence?
  # end
  #
  # def recurring_or_recurrence?
  #   recurring? || self.recurrence?
  # end
  #
  # def human_readable_recurring
  #   case self.recurring_interval.to_sym
  #   when :day
  #     "daily"
  #   when :week
  #     "weekly"
  #   when :biweek
  #     "bi-weekly"
  #   when :month
  #     "monthly"
  #   when :year
  #     "yearly"
  #   end
  # end
  #
  # def save_recurrences_in_background_on_create
  #   SaveRecurringShowsWorker.perform_later self.id
  # end
  #
  # def update_recurrences_in_background
  #   # if the recurring interval was changed, we need to destroy all the recurring shows and call save_recurrences again
  #   if self.saved_changes.include?("recurring_interval") && !self.saved_changes.include?("id")
  #     self.recurrences.destroy_all
  #     SaveRecurringShowsWorker.perform_later self.id
  #   elsif update_all_recurrences?
  #     UpdateRecurringShowsWorker.perform_later self.id
  #   end
  # end
  #
  # def do_destroy_recurrences
  #   recurrences_to_update.destroy_all
  # end

  # def save_recurrences
  #   if recurring?
  #     start_and_end_recurrences.each do |s,e|
  #       scheduled_show = self.dup
  #       scheduled_show.image = self.image if self.image.present?
  #       scheduled_show.recurring_interval = self.recurring_interval
  #       scheduled_show.recurrence = true
  #       scheduled_show.recurrant_original_id = self.id
  #       scheduled_show.start_at = DateTime.new s.year, s.month, s.day, self.start_at.hour, self.start_at.min, self.start_at.sec, self.start_at.zone
  #       scheduled_show.end_at = DateTime.new e.year, e.month, e.day, self.end_at.hour, self.end_at.min, self.end_at.sec, self.end_at.zone
  #       scheduled_show.slug = nil
  #       next if scheduled_show.start_at == self.start_at
  #       scheduled_show.save!
  #     end
  #   end
  # end

  # def update_recurrences
  #   recurrences_to_update.each do |r|
  #     r.attributes = self.attributes.except("id","created_at","updated_at","start_at","end_at","recurring_interval","recurrence", "recurrant_original_id", "slug", "image")
  #     new_start_at = DateTime.new r.start_at.year, r.start_at.month, r.start_at.day, self.start_at.hour, self.start_at.min, self.start_at.sec, self.start_at.zone
  #     r.start_at = new_start_at
  #     new_end_at = DateTime.new r.end_at.year, r.end_at.month, r.end_at.day, self.end_at.hour, self.end_at.min, self.end_at.sec, self.end_at.zone
  #     r.end_at = new_end_at
  #     r.image = self.image if self.image.present?
  #     r.update_all_recurrences = false
  #     r.save!
  #   end
  # end
  #
  def formatted_date
    "#{self.start_at.strftime("%m%d%Y")}"
  end

  def slug_candidates
    [
      [:title, :formatted_date],
      [:title, :formatted_date, :id]
    ]
  end

  # def fall_forward_recurrances_for_dst!
  #   recurrences_to_update.each do |r|
  #     r.update start_at: r.start_at+1.hour, end_at: r.end_at+1.hour
  #   end
  # end
  #
  # def fall_back_recurrances_for_dst!
  #   recurrences_to_update.each do |r|
  #     r.update start_at: r.start_at-1.hour, end_at: r.end_at-1.hour
  #   end
  # end

  private

  def add_performers
    if self.scheduled_show_performers.empty?
      self.performers << self.dj
    end
  end

  # def recurring_interval_changed?
  #   self.changes.has_key? "recurring_interval"
  # end
  #
  # def maybe_destroy_recurrences
  #   id = self.recurrant_original_id || self.id
  #   if destroy_recurrences
  #     DestroyRecurringShowsWorker.perform_later id
  #   end
  # end

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

  # def start_and_end_recurrences options={}
  #   starts = recurrence_times(options.merge(starts: self.start))
  #   ends = recurrence_times(options.merge(starts: self.end))
  #   if starts.length != ends.length
  #     while starts.length != ends.length
  #       if starts.length > ends.length
  #         starts.pop
  #       else
  #         ends.pop
  #       end
  #     end
  #   end
  #   starts.zip(ends)
  # end

  # def recurrence_times options={}
  #   options = {:every => self.recurring_interval}.merge(options)
  #   options[:on] = case options[:every]
  #   when 'year'
  #     [options[:starts].month, options[:starts].day]
  #   when 'week', 'biweek'
  #     options[:starts].strftime('%A').downcase.to_sym
  #   when 'day'
  #     options[:starts].day
  #   when 'month'
  #     TimeUtils.week_of_month_for_date(self.start_at)
  #   end
  #   if options[:every] == "month"
  #     options[:weekday] = self.start_at.strftime("%A").downcase.to_sym
  #   elsif options[:every] == "biweek"
  #     options[:interval] = 2
  #     options[:every] = "week"
  #   end
  #   Recurrence.new(options).events
  # end

  # def recurrences_to_update
  #   if !is_original_recurrant?
  #     self.radio.scheduled_shows.where(recurrant_original_id: self.recurrant_original_id).where("start_at > (?)", Time.current)
  #   else # this is the original recurring show!
  #     recurrences.where("start_at > (?)", Time.current)
  #   end
  # end
  #
  # def update_all_recurrences?
  #   ActiveModel::Type::Boolean.new.cast update_all_recurrences
  # end
  #
  # private
  #
  # def is_original_recurrant?
  #   !self.recurrant_original_id.present?
  # end
  #
  private
  def maybe_add_to_default_playlist
    if self.archive_published?
      self.tracks.each do |t|
        unless self.radio.default_playlist.tracks.include? t
          self.radio.default_playlist.tracks << t
          Notification.create notification_type: "new_podcast", user: self.performers.first, source: self, send_to_chat: true, send_to_user: false
        end
      end
    end
  end

  def maybe_process_recording
    if self.recording && self.recording.processing_status === 'unprocessed'
      ProcessRecordingWorker.perform_later self.recording.id, self.id
    end
  end
end
