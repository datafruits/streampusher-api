if Rails.env.production?
  events = [
            "user.signup",
            "user.updated",
            "user.canceled",
            "user.login.failed",
            "playlist.created",
            "playlist.updated",
            "playlist.deleted",
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
            "microtext.created",
            "listener.created",
            "live_now"
           ]

  events.each do |event|
    ActiveSupport::Notifications.subscribe event do |*args|
      event = ActiveSupport::Notifications::Event.new *args
      DiscordNotifier.perform_later "#{event.name}: #{event.payload.inspect}", ENV['DISCORD_ACTIVITY_WEBHOOK_URL']
    end
  end

  ActiveSupport::Notifications.subscribe "host_application.created" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "New DJ Application: \n name: #{event.payload[:username]} \n link: #{event.payload[:link]}"
  end

  ActiveSupport::Notifications.subscribe "live_now" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "#{event.payload[:user]} is live now!"
  end
end
