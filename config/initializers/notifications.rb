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
            "live_now",
            "wiki_page.created",
            "wiki_page.updated",
            "forum_thread.created",
            "post.created",
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
    DiscordNotifier.perform_later "#{event.payload[:user]} is live now!", ENV['DISCORD_LIVE_BOT_WEBHOOK_URL']
  end

  ActiveSupport::Notifications.subscribe "forum_thread.created" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "New forum post by #{event.payload[:username]}: #{event.payload[:forum_thread]}", ENV['DISCORD_FORUM_BOT_WEBHOOK_URL']
  end

  ActiveSupport::Notifications.subscribe "post.created" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "New reply by #{event.payload[:username]}: #{event.payload[:post]}", ENV['DISCORD_FORUM_BOT_WEBHOOK_URL']
  end

  ActiveSupport::Notifications.subscribe "wiki_page.created" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "New wiki page created by #{event.payload[:username]}: #{event.payload[:wiki_page]}", ENV['DISCORD_WIKI_BOT_WEBHOOK_URL']
  end

  ActiveSupport::Notifications.subscribe "wiki_page.update" do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    DiscordNotifier.perform_later "Wiki page updated by #{event.payload[:username]}: #{event.payload[:wiki_page]}", ENV['DISCORD_WIKI_BOT_WEBHOOK_URL']
  end
end
