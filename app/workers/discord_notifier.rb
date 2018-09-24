class DiscordNotifier < ActiveJob::Base
  queue_as :default

  def perform message
    Discord::Notifier.message(message)
  end
end
