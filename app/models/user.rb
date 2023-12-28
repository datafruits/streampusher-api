class User < ActiveRecord::Base
  include ::User::Roles
  include ::User::Rpg

  has_one :subscription
  has_many :microtexts
  has_many :user_radios
  has_many :radios, through: :user_radios
  has_many :shows, foreign_key: :dj_id
  has_many :recordings
  has_many :social_identities
  has_many :scheduled_show_performers, class_name: "::ScheduledShowPerformer", dependent: :destroy
  has_many :performers, through: :scheduled_show_performers, source: :user
  has_many :scheduled_shows, -> { includes :tracks }, through: :scheduled_show_performers
  has_many :tracks, through: :scheduled_shows
  has_many :track_favorites
  has_many :fruit_summons
  has_many :posts
  has_many :notifications

  has_attached_file :image, styles: { :thumb => "150x150#", :medium => "250x250#" },
    path: ":attachment/:style/:basename.:extension"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  default_scope { order(created_at: :desc) }

  scope :profile_published, -> { where(profile_publish: true) }

  enum style: [
    :funny,
    :gooey,
    :party,
    :fruity,
    :prickly,
    :cold,
    :goofy,
    :funky,
    :freaky,
    :fishy,
    :undefined,
    :chunky,
    :doom,
    :sleepy,
    :thinking,
    :slimey,
    :pokey,
    :grumpy,
    :fancy,
    :sexy,
    :sadness,
    :chill,
    :layzee,
    :unknown,
  ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :username, with: /\A[a-zA-Z0-9_\.]+\z/, message: :alphanumeric
  validates_presence_of :time_zone
  validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.all.map { |m| m.name }, :message => "is not a valid Time Zone"

  before_validation :set_username, :set_initial_time_zone

  after_create :send_notification

  after_update :maybe_send_update_notification

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def connected_identity? provider
    self.social_identities.where(provider: provider).any?
  end

  def soft_delete
    update_attribute :deleted_at, Time.current
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at && self.enabled?
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def jwt_payload
    { 'username' => self.username }
  end

  private
  def set_username
    if email.present?
      self.username = email.split('@').first if self.username.blank?
      self.username.downcase!
    end
  end

  def set_initial_time_zone
    # TODO should set time zone from browser timezone in form
    unless self.time_zone.present?
      self.time_zone = Time.zone.name
    end
  end

  def send_notification
    Notification.create! notification_type: "new_datafruiter", source: self, send_to_chat: true, send_to_user: false, user: self
  end

  def maybe_send_update_notification
    if self.saved_change_to_bio?
      Notification.create! notification_type: "profile_update", source: self, send_to_chat: true, send_to_user: false, user: self
    elsif self.saved_change_to_image_file_name?
      Notification.create! notification_type: "avatar_update", source: self, send_to_chat: true, send_to_user: false, user: self
    end
  end
end
