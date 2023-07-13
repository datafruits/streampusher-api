require 'exception_notification/rails'
require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production?
  end
  config.add_notifier :email, {
    :email_prefix => "[Exception] ",
    :sender_address => %{"Exception Notifier" <exception@streampusher.com>},
    :exception_recipients => %w{info@streampusher.com}
  }

  # this is actually for discord
  config.add_notifier :slack, {
    webhook_url: "#{ENV['DISCORD_ERROR_WEBHOOK_URL']}/slack"
  }
end
