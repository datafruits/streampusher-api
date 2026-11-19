class ShowSeries < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :radio
  belongs_to :default_playlist, class_name: "Playlist"
  has_many :show_series_hosts, class_name: "::ShowSeriesHost", dependent: :destroy
  has_many :users, through: :show_series_hosts

  has_many :show_series_labels, dependent: :destroy
  has_many :labels, through: :show_series_labels

  has_many :episodes, class_name: "::ScheduledShow"

  # has_attached_file :image,
  #   styles: { :thumb => "x300", :medium => "x600" },
  #   path: ":attachment/:style/:basename.:extension",
  #   validate_media_type: false # TODO comment out for prod
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  #
  alias_attribute :image, :as_image

  has_one_attached :as_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end

  enum status: [:active, :archived, :disabled]

  enum recurring_interval: [:not_recurring, :day, :week, :month, :year, :biweek]
  enum recurring_weekday: [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ]
  enum recurring_cadence: ['First', 'Second', 'Third', 'Fourth', 'Last']

  validates_presence_of :title, :description
  # TODO this doesn't check for overlapping times at all, disabling for now
  # validate :recurring_cadence_is_unique
  validates_presence_of :time_zone
  validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.all.map { |m| m.name }, :message => "is not a valid Time Zone"


  after_create :save_recurrences_in_background_on_create, if: :recurring?
  after_update :update_episodes_in_background, if: :should_update_episodes?

  before_save :set_required_columns

  # very destructive
  def convert_to! interval, new_start_date
    case interval.to_sym
    when :biweek
      # TODO sometimes have to subtract 2 weeks for recurrences to generate properly???
      # will investigate further
      # self.update start_date: new_start_date - 2.weeks, recurring_interval: interval
      self.update start_date: new_start_date, recurring_interval: interval
      self.episodes.where("start_at >= ?", new_start_date).destroy_all
      self.save_episodes
    end
  end

  def recurrences
    options = { every: self.recurring_interval.to_sym }
    options[:starts] = self.start_date
    case self.recurring_interval.to_sym
    # TODO
    # when "day"
    when :week
      options[:on] = self.recurring_weekday.downcase.to_sym
    when :biweek
      options[:every] = :week
      options[:on] = self.recurring_weekday.downcase.to_sym
      options[:interval] = 2
    when :month
      options[:weekday] = self.recurring_weekday.downcase.to_sym
      options[:on] = self.recurring_cadence.downcase.to_sym
    when :year
      # FIXME this doesn't seem to create the show for the current year,
      # it starts on the next one
      options[:on] = [self.start_date.month, self.start_date.day]
    end
    Recurrence.new options
  end

  def slug_candidates
    [
      [:title],
      [:title, :id]
    ]
  end

  def save_episodes
    if recurring?
      recurrences.each do |date|
        start_at, end_at = episode_times_on(date)

        if start_at > Time.now
          scheduled_show = self.episodes.new
          scheduled_show.radio = self.radio
          scheduled_show.dj = self.users.first # TODO drop dj_id from ScheduledShow?
          # add performers
          scheduled_show.performers << self.users

          scheduled_show.start_at = start_at
          scheduled_show.end_at = end_at
          scheduled_show.slug = nil
          scheduled_show.title = self.title
          if self.default_playlist.present?
            scheduled_show.playlist = self.default_playlist
          else
            scheduled_show.playlist = self.radio.default_playlist
          end
          scheduled_show.save!
        end
      end
    end
  end

  def update_episodes
    episodes_to_update.each do |episode|
      date = episode.start_at.in_time_zone(time_zone).to_date
      episode.start_at, episode.end_at = episode_times_on(date)
      # TODO title, description
      # not sure how that should work
      unless episode.image.present?
        episode.image = self.image if self.image.present?
      end
      episode.save!
    end
  end

  private

  def episode_times_on(date)
    zone = Time.find_zone!(time_zone)
    local_start = start_time.in_time_zone(zone)
    local_end = end_time.in_time_zone(zone)
    start_at = zone.local(date.year, date.month, date.day, local_start.hour, local_start.min)
    duration_minutes = (local_end.hour * 60 + local_end.min) - (local_start.hour * 60 + local_start.min)

    end_at = if duration_minutes.negative?
      # Resolve the end on the next calendar day so it uses that day's UTC offset.
      next_date = date.next_day
      zone.local(next_date.year, next_date.month, next_date.day, local_end.hour, local_end.min)
    else
      start_at + duration_minutes.minutes
    end

    [start_at, end_at]
  end

  def set_required_columns
    if self.year? && self.recurring_weekday.blank?
      self.recurring_weekday = 'Sunday'
    end
  end

  def episodes_to_update
    self.episodes.where("start_at > (?)", Time.current)
  end

  def recurring_cadence_is_unique
    if self.active?
      case self.recurring_interval
      # TODO
      # when "day"
      when "week"
        # scope by weekday
      when "biweek"
        # scope by week and weekday
      when "month"
        if ShowSeries.where(recurring_interval: self.recurring_interval, recurring_weekday: self.recurring_weekday, recurring_cadence: self.recurring_cadence, status: :active).where.not(id: self.id).exists?
          return self.errors.add(:recurring_cadence, "This monthly slot is already taken")
        end
      end
    end
  end

  def recurring?
    !self.not_recurring?
  end

  def save_recurrences_in_background_on_create
    SaveRecurringShowsWorker.perform_later self.id
  end

  def should_update_episodes?
    return saved_change_to_start_time? ||
      saved_change_to_end_time? ||
      saved_change_to_image_updated_at? ||
      saved_change_to_description? ||
      saved_change_to_title?
  end

  def update_episodes_in_background
    UpdateRecurringShowsWorker.perform_later self.id
  end
end
