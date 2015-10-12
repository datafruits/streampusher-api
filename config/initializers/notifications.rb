if Rails.env.production?
  events = [
            "user.signup",
            "playlist.created",
            "track.created",
            "dj.created",
            "podcast.created",
            "scheduled_show.created",
            "show.created"
           ]

  events.each do |event|
    ActiveSupport::Notifications.subscribe event do |*args|
      event = ActiveSupport::Notifications::Event.new *args
      SlackNotifier.perform_later "#{event.name}: #{event.payload.inspect}"
    end
  end
end
