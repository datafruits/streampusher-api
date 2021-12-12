class HostApplication < ApplicationRecord
  belongs_to :radio

  validates :email, presence: true
  validates :username, presence: true
  validate :username_not_taken, on: :create
  validate :email_not_taken, on: :create
  validates_format_of :username, with: /\A[a-zA-Z0-9_\.]+\z/, message: :alphanumeric
  validates :link, presence: true
  validates :desired_time, presence: true
  validates_presence_of :time_zone
  validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.all.map { |m| m.name }, :message => "is not a valid Time Zone"

  before_validation :process_time_zone

  enum interval: [:daily, :weekly, :biweekly, :monthly, :other]

  def approve!
    return false if approved?
    params = self.attributes.slice "username", "email", "time_zone"
    user = DjSignup.perform params, self.radio
    if user.persisted?
      update! approved: true
    else
      raise "Couldn't create user account: #{user.errors.inspect}"
    end
  end

  private

  def username_not_taken
    if User.where(username: username).where.not("role LIKE ?", "%listener%").or(User.where(username: username, role: nil)).any?
      errors.add(:username, "is already taken")
    end
  end

  def email_not_taken
    if User.where(username: username).where.not("role LIKE ?", "%listener%").or(User.where(username: username, role: nil)).any?
      errors.add(:email, "is already taken")
    end
  end

  def process_time_zone
    return if ActiveSupport::TimeZone.all.map { |m| m.name }.include? time_zone
    tz = TZInfo::Timezone.get self.time_zone
    offset = tz.period_for_utc(Time.now).offset.utc_total_offset
    self.time_zone = ActiveSupport::TimeZone.all.select{ |s| s.utc_offset == offset }.first.name
  end
end
