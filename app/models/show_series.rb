class ShowSeries < ApplicationRecord
  has_many :show_series_hosts, class_name: "::ShowSeriesHost", dependent: :destroy
  has_many :users, through: :show_series_hosts

  has_many :show_series_labels, dependent: :destroy
  has_many :labels, through: :show_series_labels

  has_many :scheduled_shows

  # TODO move to active storage I guess?
  # has_one_attached :image
  has_attached_file :image,
    styles: { :thumb => "x300", :medium => "x600" },
    path: ":attachment/:style/:basename.:extension"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

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
end
