if Rails.env.production?
  events = [
            "user.signup",
            "user.updated",
            "user.canceled",
            "playlist.created",
            "playlist.updated",
            "track.created",
            "dj.created",
            "dj.added_to_radio",
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
