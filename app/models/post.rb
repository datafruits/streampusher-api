class Post < ApplicationRecord
  after_create :maybe_send_notification

  VALID_POSTABLE_TYPES = ['ForumThread', 'ScheduledShow']
  belongs_to :postable, polymorphic: true, touch: true
  belongs_to :user

  private
  def maybe_send_notification
    if self.postable_type === "ScheduledShow"
      show = self.postable
      show.users.each do |user|
        Notification.create notification_type: :show_comment, source: show, to_user: user, send_to_chat: false
      end
    end
  end
end
