class User < ActiveRecord::Base
  has_one :subscription
  has_many :radios, through: :user_radios
  has_many :user_radios

  # include User::Roles
  ROLES = %w[admin dj]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validate :valid_role
  validates_presence_of :username
  validates_uniqueness_of :username

  before_validation :set_username

  def managable_radios
    self.subscription.radios
  end

  def valid_role
    if !role.to_s.blank?
      self.roles.each do |r|
        if !ROLES.include?(r)
          errors.add :role, "is not a valid role."
        end
      end
    end
  end

  ROLES.each do |r|
    define_method "#{r}?" do
      has_role? r
    end
  end

  def has_role?(r)
    roles.include?(r)
  end

  def roles
    self.role.to_s.split(' ')
  end

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

  private
  def set_username
    self.username = email.split('@').first if self.username.blank?
  end
end
