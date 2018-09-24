if Rails.env.production?
  events = [
            "user.signup",
            "user.updated",
            "user.canceled",
            "user.login.failed",
            "playlist.created",
            "playlist.updated",
            "track.created",
            "track.updated",
            "dj.created",
            "dj.added_to_radio",
            "podcast.created",
            "scheduled_show.created",
            "scheduled_show.updated",
            "scheduled_show.deleted",
            "subscription.updated",
            "radio.down",
           ]

  events.each do |event|
    ActiveSupport::Notifications.subscribe event do |*args|
      event = ActiveSupport::Notifications::Event.new *args
      SlackNotifier.perform_later "#{event.name}: #{event.payload.inspect}"
    end
  end

  ActiveSupport::Notifications.subscribe "host_application.created" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "New DJ Application: #{event.payload.inspect}"
  end
end
