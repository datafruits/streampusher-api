class ShowSeries < ApplicationRecord
  has_many :show_series_hosts, class_name: "::ShowSeriesHost", dependent: :destroy
  has_many :users, through: :show_series_hosts

  has_many :show_series_labels, dependent: :destroy
  has_many :labels, through: :show_series_labels

  has_many :scheduled_shows

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
end
