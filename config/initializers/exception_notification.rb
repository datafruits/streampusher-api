require 'exception_notification/rails'
require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  :email => {
    :email_prefix => "[Exception] ",
    :sender_address => %{"Exception Notifier" <exception@streampusher.com>},
    :exception_recipients => %w{info@datafruits.fm}
  }

  :slack => {
    :webhook_url => "https://hooks.slack.com/services/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",
    :channel => "#general",
    :additional_parameters => {
      #:icon_url => "http://image.jpg",
      :icon_emoji => "boom",
      :mrkdwn => true
    }
  }
end
