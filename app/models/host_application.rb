class HostApplication < ApplicationRecord
  belongs_to :radio

  validates :email, presence: true
  validates :username, presence: true
  validate :username_not_taken
  validate :email_not_taken
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :username, with: /\A[a-zA-Z0-9_\.]+\z/, message: :alphanumeric
  validates :link, presence: true
  validates :desired_time, presence: true
  validates_presence_of :time_zone
  validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.all.map { |m| m.name }, :message => "is not a valid Time Zone"

  enum interval: [:weekly, :biweekly, :monthly, :other]

  def approve!
    return false if approved?
    params = self.attributes.slice "username", "email", "time_zone"
    user = DjSignup.perform params, self.radio
    if user.persisted?
      update! approved: true
    else
      raise "Couldn't create user account"
    end
  end

  private
  def username_not_taken
    unless User.where(username: username).none?
      errors.add(:username, "is already taken")
    end
  end

  def email_not_taken
    unless User.where(email: email).none?
      errors.add(:email, "is already taken")
    end
  end
end
