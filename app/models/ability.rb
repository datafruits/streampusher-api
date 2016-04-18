class Ability
  include CanCan::Ability

  def initialize(user, radio, format)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :admin, :dashboard
      can :admin, :radios
      can :admin, :sign_in_as
      can :manage, :all
    elsif user.owner?
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :manage, :dj if can_manage_radio?(user, radio)
      can :manage, Show if can_manage_radio?(user, radio)
      can :manage, Track if can_manage_radio?(user, radio)
      can :manage, Playlist if can_manage_radio?(user, radio)
      can :manage, PlaylistTrack if can_manage_radio?(user, radio)
      can :manage, Subscription, user_id: user.id
      can :manage, ScheduledShow if can_manage_radio?(user, radio)
      can :manage, Podcast if can_manage_radio?(user, radio)
      can :read, "broadcasting_help"
      can :read, "embed"
      can :manage, Recording if can_manage_radio?(user, radio)
      can :vj, :dashboard if is_datafruits?(radio)
    elsif user.manager? # same as owner except can't manage subscription
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :manage, :dj if can_manage_radio?(user, radio)
      can :manage, Show if can_manage_radio?(user, radio)
      can :manage, Track if can_manage_radio?(user, radio)
      can :manage, Playlist if can_manage_radio?(user, radio)
      can :manage, PlaylistTrack if can_manage_radio?(user, radio)
      can :manage, ScheduledShow if can_manage_radio?(user, radio)
      can :manage, Podcast if can_manage_radio?(user, radio)
      can :read, "broadcasting_help"
      can :read, "embed"
      can :manage, Recording if can_manage_radio?(user, radio)
      can :vj, :dashboard if is_datafruits?(radio)
    elsif user.dj?
      can :index, Radio if can_manage_radio?(user, radio)
      can :read, Podcast

      can :read, Show
      can :create, Show, dj_id: user.id
      can :update, Show, dj_id: user.id
      can :destroy, Show, dj_id: user.id

      can :read, ScheduledShow
      can :create, ScheduledShow
      can :update, ScheduledShow
      can :destroy, ScheduledShow

      can :read, Track if can_manage_radio?(user, radio)
      can :create, Track if can_manage_radio?(user, radio)
      can :update, Track if can_manage_radio?(user, radio)

      can :show, Playlist if can_manage_radio?(user, radio)
      can :index, Playlist if can_manage_radio?(user, radio)

      can :read, "broadcasting_help"
      can :read, "embed"

      can :vj, :dashboard if is_datafruits?(radio)
      cannot :admin
    else
      can :read, ScheduledShow if format == "json"
      can :next, ScheduledShow if format == "json"
      can :enabled, :vj
      cannot :admin
    end
  end

  private
  def is_datafruits?(radio)
    radio.name == "datafruits"
  end

  def can_manage_radio?(user, radio)
    user.radios.include? radio
  end
end
