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

  config.add_notifier :slack, {
    :webhook_url => "https://hooks.slack.com/services/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",
    :channel => "#dev",
    :additional_parameters => {
      #:icon_url => "http://image.jpg",
      :icon_emoji => "boom",
      :mrkdwn => true
    }
  }

  config.add_notifier :slack, {
    webhook_url: ENV['DISCORD_ERROR_WEBHOOK_URL']
  }
end
