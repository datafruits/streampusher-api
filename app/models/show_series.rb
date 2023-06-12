class ShowSeries < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_many :show_series_hosts, class_name: "::ShowSeriesHost", dependent: :destroy
  has_many :users, through: :show_series_hosts

  has_many :show_series_labels, dependent: :destroy
  has_many :labels, through: :show_series_labels

  has_many :episodes, class_name: "::ScheduledShow"
  
  # TODO move to active storage I guess?
  # has_one_attached :image
  has_attached_file :image,
    styles: { :thumb => "x300", :medium => "x600" },
    path: ":attachment/:style/:basename.:extension",
    validate_media_type: false # TODO comment out for prod
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  enum status: [:active, :archived, :disabled]

  enum recurring_interval: [:not_recurring, :day, :week, :month, :year, :biweek]
  enum recurring_weekday: [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thusday',
    'Friday',
    'Saturday'
  ]
  enum recurring_cadence: ['First', 'Second', 'Third', 'Forth', 'Last']

  validate :recurring_cadence_is_unique

  # after_create :save_recurrences_in_background_on_create, if: :recurring?
  # after_update :update_recurrences_in_background, if: :recurring_or_recurrence?

  def image_url
    self.image.url(:original)
  end

  def thumb_image_url
    self.image.url(:thumb)
  end

  def save_recurrences
# # Monthly by week day
# r = Recurrence.new(every: :month, on: :first, weekday: :sunday)
# r = Recurrence.new(every: :month, on: :third, weekday: :monday)
# r = Recurrence.new(every: :month, on: :last,  weekday: :friday)
# r = Recurrence.new(every: :month, on: :last,  weekday: :friday, interval: 2)
# r = Recurrence.new(every: :month, on: :last,  weekday: :friday, interval: :quarterly)
# r = Recurrence.new(every: :month, on: :last,  weekday: :friday, interval: :semesterly)
# r = Recurrence.new(every: :month, on: :last,  weekday: :friday, repeat: 3)
  end

  def recurrence_times options={}
    options = {:every => self.recurring_interval}.merge(options)
    options[:on] = self.recurring_cadence.downcase.to_sym
    options[:weekday] = self.recurring_weekday.downcase.to_sym

    if options[:every] == "biweek"
      options[:interval] = 2
      options[:every] = "week"
    end
    Recurrence.new(options).events
  end

  def slug_candidates
    [
      [:title],
      [:title, :id]
    ]
  end

  private
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
        if ShowSeries.where(recurring_interval: self.recurring_interval, recurring_weekday: self.recurring_weekday, recurring_cadence: self.recurring_cadence).where.not(id: self.id).exists?
          return self.errors.add(:recurring_cadence, "This monthly slot is already taken")
        end
      end
    end
  end
end
