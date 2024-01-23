class Shrimpo < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_many :shrimpo_entries

  has_one_attached :zip

  validates :title, presence: true

  enum status: [:running, :voting, :completed]

  attr_accessor :duration

  after_create :queue_end_shrimpo_job

  VALID_DURATIONS = [
    "1 hour",
    "2 hours",
    "4 hours",
    "1 day",
    "2 days",
    "1 week",
  ]

  def duration
    time_ago_in_words(self.end_at - self.start_at)
  end

  def duration= d
    if VALID_DURATIONS.include? d
      # using eval is an extremely *safe* ~good~ thing TO DO >: 3
      self.end_at = self.start_at + eval(d.gsub(' ', '.'))
    end
  end

  def slug_candidates
    [
      [:title],
      [:title, :id]
    ]
  end

  private
  def queue_end_shrimpo_job
    EndShrimpoWorker.set(wait: duration).perform_later(self)
  end
end
