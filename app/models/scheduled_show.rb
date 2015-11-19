class ScheduledShow < ActiveRecord::Base
  belongs_to :radio
  belongs_to :show
  belongs_to :playlist
  belongs_to :recurrant_original, class_name: "ScheduledShow"
  has_attached_file :image, styles: { :thumb => "x300" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :start_at, :end_at
  validates_presence_of :show_id
  validates :description, length: { maximum: 10000 }

  alias_attribute :start, :start_at
  alias_attribute :end, :end_at
  attr_accessor :update_all_recurrences

  after_save :persist_to_redis

  before_save :update_recurring_intervals
  after_create :save_recurrences
  after_update :update_recurrences

  enum recurring_interval: [:not_recurring, :day, :week, :month, :year]

  # TODO
  # validate :time_is_in_15_min_intervals

  def title
    self.show.title
  end

  def dj
    self.show.dj
  end

  def image_url
    if self.image.present?
      self.image.url(:original)
    else
      self.show.image.url(:original)
    end
  end

  def thumb_image_url
    if self.image.present?
      self.image.url(:thumb)
    else
      self.show.image.url(:thumb)
    end
  end

  def schedule_cannot_conflict
    self.radio.scheduled_shows.where.not(id: id).each do |show|
      if end_at > show.start_at && start_at < show.end_at
        errors.add(:time, " conflict detected with show '#{show.user.username} - #{show.title}'. Please choose a different time.")
      end
    end
  end

  def time_keys
    cur_time = self.start_at.utc
    time_keys = []
    while cur_time < self.end_at.utc do
      date = cur_time.strftime("%m%d%Y")
      hours_mins = cur_time.strftime("%Hh%Mm")
      time_keys << "#{date}:#{hours_mins}"
      cur_time = cur_time + 15.minutes
    end

    time_keys
  end

  def redis_keys
    time_keys.map{|key| "#{self.radio.name}:schedule:#{key}"}
  end

  def persist_to_redis redis=Redis.current
    redis_keys.each do |key|
      redis.set key, self.show.playlist.redis_key
    end
  end

  def recurrences
    self.class.where(recurrant_original_id: self.id)
  end

  def destroy_all_recurrences
    recurrences_to_update.destroy_all
  end

  def recurring?
    !self.not_recurring?
  end

  private
  def start_and_end_recurrences options={}
    recurrence_times(options.merge(starts: self.start)).zip(recurrence_times(options.merge(starts: self.end)))
  end

  def recurrence_times options={}
    options = {:every => self.recurring_interval}.merge(options)
    options[:on] = case options[:every]
    when 'year'
      [options[:starts].month, options[:starts].day]
    when 'week'
      options[:starts].strftime('%A').downcase.to_sym
    when 'day', 'month'
      options[:starts].day
    end
    Recurrence.new(options).events
  end

  def save_recurrences
    if recurring?
      start_and_end_recurrences.each do |s,e|
        scheduled_show = self.dup
        scheduled_show.recurring_interval = "not_recurring"
        scheduled_show.recurrence = true
        scheduled_show.recurrant_original_id = self.id
        scheduled_show.start_at = DateTime.new s.year, s.month, s.day, self.start_at.hour, self.start_at.min, self.start_at.sec, self.start_at.zone
        scheduled_show.end_at = DateTime.new e.year, e.month, e.day, self.end_at.hour, self.end_at.min, self.end_at.sec, self.end_at.zone
        scheduled_show.save!
      end
    end
  end

  def update_recurrences
    if update_all_recurrences == true
      recurrences_to_update.each do |r|
        r.attributes = self.attributes.except("id","created_at","updated_at","start_at","end_at","recurring_interval","recurrence")
        new_start_at = DateTime.new r.start_at.year, r.start_at.month, r.start_at.day, self.start_at.hour, self.start_at.min, self.start_at.sec, self.start_at.zone
        r.start_at = new_start_at
        new_end_at = DateTime.new r.end_at.year, r.end_at.month, r.end_at.day, self.end_at.hour, self.end_at.min, self.end_at.sec, self.end_at.zone
        r.end_at = new_end_at
        r.save!
      end
    end
  end

  def update_recurring_intervals
    # if the recurring interval was changed, we need to destroy all the recurring shows and call save_recurrences again
    if self.changes.include?("recurring_interval") && !self.new_record?
      self.recurrences.destroy_all
      save_recurrences
    end
  end

  def recurrences_to_update
    if self.recurrant_original_id.present? # find the original recurrent
      recurrences_to_update = self.recurrant_original.recurrences
    else # this is the original recurring show!
      recurrences_to_update = recurrences
    end
  end
end
