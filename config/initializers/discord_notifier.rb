Discord::Notifier.setup do |config|
  config.url = ENV['DISCORD_WEBHOOK_URL']
  config.username = 'fruit bot'

  # Defaults to `false`
  config.wait = true
end
