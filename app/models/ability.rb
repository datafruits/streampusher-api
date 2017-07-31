class Ability
  include CanCan::Ability

  def initialize(user, radio, format)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :admin, :dashboard
      can :admin, :radios
      can :admin, :sign_in_as
      can :index, :stats if can_manage_radio?(user, radio)
      can :manage, :all
      can :update, :metadata
    elsif user.owner?
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :index, :stats if can_manage_radio?(user, radio)
      can :manage, :dj if can_manage_radio?(user, radio)
      can :manage, Track if can_manage_radio?(user, radio)
      can :manage, Label if can_manage_radio?(user, radio)
      can :index, Label if format == "json"
      can :manage, Playlist do |playlist|
        can_manage_radio?(user, radio) && belongs_to_radio?(playlist, radio)
      end
      can :manage, PlaylistTrack do |playlist_track|
        can_manage_radio?(user, radio) && belongs_to_radio?(playlist_track.playlist, radio)
      end
      can :manage, Subscription, user_id: user.id
      can :manage, ScheduledShow do |scheduled_show|
        can_manage_radio?(user, radio) && belongs_to_radio?(scheduled_show, radio)
      end
      can :manage, Podcast if can_manage_radio?(user, radio) && radio.podcasts_enabled?
      can :read, "embed"
      can :manage, Recording if can_manage_radio?(user, radio)
      can :vj, :dashboard if is_datafruits?(radio)
      can :manage, SocialIdentity
      can :update, :metadata if can_manage_radio?(user, radio)

      can :index, Listen
    elsif user.manager? # same as owner except can't manage subscription
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :index, :stats if can_manage_radio?(user, radio)
      can :manage, :dj if can_manage_radio?(user, radio)
      can :manage, Track if can_manage_radio?(user, radio)
      can :manage, Label if can_manage_radio?(user, radio)
      can :index, Label if format == "json"
      can :manage, Playlist do |playlist|
        can_manage_radio?(user, radio) && belongs_to_radio?(playlist, radio)
      end
      can :manage, PlaylistTrack do |playlist_track|
        can_manage_radio?(user, radio) && belongs_to_radio?(playlist_track.playlist, radio)
      end
      can :manage, ScheduledShow do |scheduled_show|
        can_manage_radio?(user, radio) && belongs_to_radio?(scheduled_show, radio)
      end
      can :manage, Podcast if can_manage_radio?(user, radio) && radio.podcasts_enabled?
      can :read, "embed"
      can :manage, Recording if can_manage_radio?(user, radio)
      can :vj, :dashboard if is_datafruits?(radio)
      can :manage, SocialIdentity, user_id: user.id
      can :update, :metadata if can_manage_radio?(user, radio)

      can :index, Listen
    elsif user.dj?
      can :index, Radio if can_manage_radio?(user, radio)
      can :read, Podcast if radio.podcasts_enabled?
      can :index, :stats if can_manage_radio?(user, radio)

      can :read, ScheduledShow do |scheduled_show|
        can_manage_radio?(user, radio) && belongs_to_radio?(scheduled_show, radio)
      end
      can :create, ScheduledShow do |scheduled_show|
        can_manage_radio?(user, radio) && belongs_to_radio?(scheduled_show, radio)
      end
      can :update, ScheduledShow do |scheduled_show|
        can_manage_radio?(user, radio) && belongs_to_radio?(scheduled_show, radio)
      end
      can :destroy, ScheduledShow do |scheduled_show|
        can_manage_radio?(user, radio) && belongs_to_radio?(scheduled_show, radio)
      end

      can :read, Track if can_manage_radio?(user, radio)
      can :create, Track if can_manage_radio?(user, radio)
      can :update, Track if can_manage_radio?(user, radio)
      can :read, Label if can_manage_radio?(user, radio)
      can :create, Label if can_manage_radio?(user, radio)
      can :update, Label if can_manage_radio?(user, radio)
      can :index, Label if format == "json"

      can :manage, Playlist do |playlist|
        can_manage_radio?(user, radio) && belongs_to_radio?(playlist, radio)
      end

      can :manage, PlaylistTrack do |playlist_track|
        can_manage_radio?(user, radio) && belongs_to_radio?(playlist_track.playlist, radio)
      end

      can :read, "embed" if can_manage_radio?(user, radio)

      can :manage, SocialIdentity, user_id: user.id

      can :vj, :dashboard if is_datafruits?(radio)
      can :manage, SocialIdentity, user_id: user.id

      can :create, :anniversary_slot if is_datafruits?(radio)
      can :index, :anniversary_slot if is_datafruits?(radio)
      can :update, :metadata if can_manage_radio?(user, radio)

      can :index, Listen
      cannot :admin
    else
      can :read, ScheduledShow if format == "json"
      can :index, :dj if format == "json"
      can :read, :dj if format == "json"
      can :next, ScheduledShow if format == "json"
      can :enabled, :vj
      can :embed, Track
      cannot :index, :stats
      can :index, Label if format == "json"
      cannot :admin
      can :sign_up, :anniversary_slot if is_datafruits?(radio)
    end
  end

  private
  def is_datafruits?(radio)
    radio.try(:name) == "datafruits"
  end

  def can_manage_radio?(user, radio)
    user.radios.include? radio
  end

  def belongs_to_radio?(model, radio)
    if model.persisted?
      model.radio_id.to_i == radio.id.to_i
    else
      return true
    end
  end
end
