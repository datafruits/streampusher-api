class EndShrimpoWorker < ActiveJob::Base
  queue_as :default

  def perform shrimpo_id
    shrimpo = Shrimpo.find shrimpo_id
    return unless shrimpo.running?
    shrimpo.voting!
    Notification.create! notification_type: :shrimpo_voting_started, source: shrimpo, send_to_chat: true, send_to_user: false, user: shrimpo.user
  end
end
