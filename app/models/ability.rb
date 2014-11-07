class Ability
  include CanCan::Ability

  def initialize(user, radio)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :manage, Radio, user_id: user.id
      can :manage, Show if can_manage_radio?(user, radio)
    end
  end

  private
  def can_manage_radio?(user, radio)
    user.managable_radios.include? radio
  end
end
