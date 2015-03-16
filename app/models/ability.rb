class Ability
  include CanCan::Ability

  def initialize(user, radio)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :admin, :dashboard
      can :admin, :radios
      can :manage, :all
    elsif user.dj?
      cannot :admin
    else
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :manage, Show if can_manage_radio?(user, radio)
    end
  end

  private
  def can_manage_radio?(user, radio)
    user.managable_radios.include? radio
  end
end
