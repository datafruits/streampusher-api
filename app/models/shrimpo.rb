class Shrimpo < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_many :shrimpo_entries
  has_many :posts, as: :postable

  has_one_attached :zip
  has_one_attached :cover_art

  validates :title, presence: true
  validates :emoji, presence: true
  validates :rule_pack, presence: true

  enum status: [:running, :voting, :completed]

  attr_accessor :duration

  after_create :queue_end_shrimpo_job

  VALID_DURATIONS = [
    # minors
    "1 hour",
    "2 hours",
    "4 hours",
    "1 day",
    "2 days",
    "1 week",
    "2 weeks",
    # majors
    "1 month",
    "3 months",
  ]

  def fruit_ticket_deposit_amount
    case self.duration.gsub(/about /, '')
    when '1 hour'
      500
    when '2 hours'
      750
    when '4 hours'
      1000
    when '1 day'
      1500
    when '2 days'
      1750
    when '1 week'
      2000
    when '1 month'
      5000
    when '3 months'
      7500
    end
  end

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

  def save_and_deposit_fruit_tickets!
    ActiveRecord::Base.transaction do
      transaction = FruitTicketTransaction.new from_user: self.user, amount: self.fruit_ticket_deposit_amount, transaction_type: :shrimpo_deposit
      transaction.transact_and_save! && self.save!
    end
  end

  def tally_results!
    return unless self.voting? && self.shrimpo_entries.any?

    ActiveRecord::Base.transaction do
      self.shrimpo_entries.each do |entry|
        total_score = entry.shrimpo_votes.sum(:score)
        entry.update! total_score: total_score
      end

      self.shrimpo_entries.sort_by(&:total_score).reverse.each_with_index do |entry, index|
        entry.update! ranking: index + 1
      end

      self.update! ended_at: Time.now
      self.completed!
      # award xp
      self.shrimpo_entries.sort_by(&:ranking).each_with_index do |entry, index|
        total_points = 2000 + (25 * self.shrimpo_entries.count)
        points = (total_points * ((8 - entry.ranking) * 0.04)).round
        ExperiencePointAward.create! user: entry.user, amount: points, award_type: :shrimpo
      end
      #
      # return deposit
      if self.shrimpo_entries.count > 2
        transaction = FruitTicketTransaction.new to_user: self.user, amount: self.fruit_ticket_deposit_amount, transaction_type: :shrimpo_deposit_return
        transaction.transact_and_save!
      end
    end
  end

  private
  def queue_end_shrimpo_job
    EndShrimpoWorker.set(wait_until: self.end_at).perform_later(self.id)
  end
end
