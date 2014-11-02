class User < ActiveRecord::Base
  has_one :subscription
  has_many :radios, through: :user_radios

  # include User::Roles
  ROLES = %w[admin dj]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validate :valid_role

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
end
