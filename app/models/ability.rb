class Ability
  include CanCan::Ability

  def initialize(user, radio)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :admin, :dashboard
      can :admin, :radios
      can :manage, :all
      can :manage, Podcast
    elsif user.dj?
      cannot :admin
      cannot :new, :create, :edit, :update, Podcast
    elsif user.persisted?
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :manage, Show if can_manage_radio?(user, radio)
      can :manage, Subscription, user_id: user.id
    else
      cannot :admin
    end
  end

  private
  def can_manage_radio?(user, radio)
    user.managable_radios.include? radio
  end
end
