class DiscordNotifier < ActiveJob::Base
  queue_as :default

  def perform message, url = ENV['DISCORD_WEBHOOK_URL']
    Discord::Notifier.message(message)
  end
end
