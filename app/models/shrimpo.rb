class Shrimpo < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_many :shrimpo_entries
  has_many :posts, as: :postable

  has_one_attached :zip
  has_one_attached :cover_art

  belongs_to :gold_trophy, class_name: "Trophy"
  belongs_to :silver_trophy, class_name: "Trophy"
  belongs_to :bronze_trophy, class_name: "Trophy"

  belongs_to :consolation_trophy, class_name: "Trophy"

  validates :title, presence: true
  validates :emoji, presence: true
  validates :rule_pack, presence: true

  validate :user_level

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
    when '7 days'
      2000
    when '1 month'
      5000
    when '3 months'
      7500
    else
      'invalid duration'
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
      # award xp & trophies
      self.shrimpo_entries.sort_by(&:ranking).each_with_index do |entry, index|
        total_points = 2000 + (25 * self.shrimpo_entries.count)
        points = (total_points * ((8 - entry.ranking) * 0.04)).round
        ExperiencePointAward.create! user: entry.user, amount: points, award_type: :shrimpo

        consolation_max = self.shrimpo_entries.count / 2

        case entry.ranking
        when 1
          TrophyAward.create! user: entry.user, trophy: self.gold_trophy, shrimpo_entry: entry
        when 2
          TrophyAward.create! user: entry.user, trophy: self.silver_trophy, shrimpo_entry: entry
        when 3
          TrophyAward.create! user: entry.user, trophy: self.bronze_trophy, shrimpo_entry: entry
        # TODO consolation_trophy
        when 4
          amount = rand(1..consolation_max)
          TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
        when 5
          amount = rand(1..consolation_max)
          TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
        when 6
          amount = rand(1..consolation_max)
          TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
        when 7
          amount = rand(1..consolation_max)
          TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
        end
      end
      #
      # return deposit
      if self.shrimpo_entries.count > 2
        transaction = FruitTicketTransaction.new to_user: self.user, amount: self.fruit_ticket_deposit_amount, transaction_type: :shrimpo_deposit_return
        transaction.transact_and_save!
      end
      # award trophies
      #
      # 1st place gold
      # 2nd place silver
      # 3rd place bronze
      # 4th-7th random amount of consolation trophies
    end
  end

  private
  def user_level
    unless self.user.level > 2
      self.errors.add(:user, " should be level 3 or higher")
    end
  end

  def queue_end_shrimpo_job
    EndShrimpoWorker.set(wait_until: self.end_at).perform_later(self.id)
  end
end
