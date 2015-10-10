class SlackNotifier < ActiveJob::Base
  queue_as :default

  def perform message
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.ping message
  end
end
