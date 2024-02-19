class Shrimpo < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_many :shrimpo_entries

  has_one_attached :zip
  has_one_attached :cover_art

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

  def sorted_entries
    self.shrimpo_entries.sort_by(&:created_at)
  end

  def duration
    time_ago_in_words(self.end_at)
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

  def tally_results!
    return unless self.voting? # && total_votes > 0

    ActiveRecord::Base.transaction do
      self.shrimpo_entries.each do |entry|
        total_score = entry.shrimpo_votes.sum(:score)
        entry.update! total_score: total_score
      end

      self.shrimpo_entries.sort_by(&:total_score).reverse.each_with_index do |entry, index|
        entry.update! ranking: index + 1
      end

      self.completed!
    end
  end

  private
  def queue_end_shrimpo_job
    EndShrimpoWorker.set(wait_until: self.end_at).perform_later(self.id)
  end
end
