class MarkNotificationsReadWorker < ActiveJob::Base
  queue_as :default

  def perform user_id
    notifications = User.find(user_id).notifications
    notifications.update_all read: true
  end
end
