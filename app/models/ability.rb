class Ability
  include CanCan::Ability

  def initialize(user, radio, format)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :admin, :dashboard
      can :admin, :radios
      can :manage, :all
    elsif user.owner?
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :manage, Show if can_manage_radio?(user, radio)
      can :manage, Track if can_manage_radio?(user, radio)
      can :manage, Playlist if can_manage_radio?(user, radio)
      can :manage, Subscription, user_id: user.id
      can :manage, ScheduledShow if can_manage_radio?(user, radio)
      can :manage, Podcast if can_manage_radio?(user, radio)
      can :read, "broadcasting_help"
    elsif user.dj?
      can :read, Podcast

      can :read, Show
      can :create, Show, dj_id: user.id
      can :update, Show, dj_id: user.id
      can :destroy, Show, dj_id: user.id

      can :read, ScheduledShow
      can :create, ScheduledShow, show_id: user.shows.pluck(:id)
      can :update, ScheduledShow, show_id: user.shows.pluck(:id)
      can :destroy, ScheduledShow, show_id: user.shows.pluck(:id)

      can :read, "broadcasting_help"
      cannot :admin
    else
      can :read, ScheduledShow if format == "json"
      cannot :admin
    end
  end

  private
  def can_manage_radio?(user, radio)
    user.radios.include? radio
  end
end
