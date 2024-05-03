require 'zip'

class Shrimpo < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_many :shrimpo_entries
  has_many :posts, as: :postable

  has_one_attached :zip
  has_one_attached :entries_zip
  has_one_attached :cover_art

  belongs_to :gold_trophy, class_name: "Trophy"
  belongs_to :silver_trophy, class_name: "Trophy"
  belongs_to :bronze_trophy, class_name: "Trophy"

  belongs_to :consolation_trophy, class_name: "Trophy"

  validates :title, presence: true
  validates :emoji, presence: true
  validates :rule_pack, presence: true

  validate :user_level

  validate :start_at_cannot_be_in_the_past, on: :create
  validate :end_at_cannot_be_in_the_past, on: :create

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
    distance_of_time_in_words(self.end_at, self.start_at)
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

    begin
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
          points = ((total_points * 0.0849) / Math.log(entry.ranking + 1)).round
          if (points > 0)
            ExperiencePointAward.create! user: entry.user, amount: points, award_type: :shrimpo, source: self
          end

          consolation_max = self.shrimpo_entries.count / 2

          case entry.ranking
          when 1
            TrophyAward.create! user: entry.user, trophy: self.gold_trophy, shrimpo_entry: entry
          when 2
            TrophyAward.create! user: entry.user, trophy: self.silver_trophy, shrimpo_entry: entry
          when 3
            TrophyAward.create! user: entry.user, trophy: self.bronze_trophy, shrimpo_entry: entry
          when 4
            amount = rand(1..consolation_max)
            amount.times do
              TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
            end
          when 5
            amount = rand(1..consolation_max)
            amount.times do
              TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
            end
          when 6
            amount = rand(1..consolation_max)
            amount.times do
              TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
            end
          when 7
            amount = rand(1..consolation_max)
            amount.times do
              TrophyAward.create! user: entry.user, trophy: self.consolation_trophy, shrimpo_entry: entry
            end
          end
        end
        #
        # return deposit
        if self.shrimpo_entries.count > 2
          transaction = FruitTicketTransaction.new to_user: self.user, amount: self.fruit_ticket_deposit_amount, transaction_type: :shrimpo_deposit_return
          transaction.transact_and_save!
        end
        ::CreateEntriesZipWorker.perform_later(self.id)
      end
    rescue => e
      puts "Tally results failed: #{e.message}"
    end
  end

  def create_entries_zip
    zip_dir = Dir.mktmpdir self.slug
    self.shrimpo_entries.each do |entry|
      file = entry.audio
      filename = entry.audio.filename.to_s
      filepath = File.join zip_dir, filename
      File.open(filepath, "wb") { |f| f.write(file.service.download(file.key)) }
    end

    temp_file = Tempfile.new("#{self.slug}.zip")
    folderpath_glob = File.join zip_dir, "**", "*"

    files = Dir.glob(folderpath_glob).reject { |e| File.directory? e }

    Zip::OutputStream.open(temp_file) { |zos| }

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      files.each do |filepath|
        filepath_zip = filepath.sub(zip_dir, '').sub(File::SEPARATOR, '')
        zip.add filepath_zip, filepath
      end
    end

    self.entries_zip.attach io: File.open(temp_file), filename: "#{self.slug}.zip"
    self.save!
  end

  private
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

  def user_level
    unless self.user.level > 2
      self.errors.add(:user, " should be level 3 or higher")
    end
  end

  def queue_end_shrimpo_job
    EndShrimpoWorker.set(wait_until: self.end_at).perform_later(self.id)
  end
end
