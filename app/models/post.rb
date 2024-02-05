class Post < ApplicationRecord
  after_create :maybe_send_notification

  VALID_POSTABLE_TYPES = ['ForumThread', 'ScheduledShow']
  belongs_to :postable, polymorphic: true, touch: true
  belongs_to :user

  def url
    if self.postable_type === "ScheduledShow"
      self.postable.url
    elsif self.postable_type === "ForumThread"
      "https://datafruits.fm/forum/#{self.postable.slug}"
    end
  end

  private
  def maybe_send_notification
    if self.postable_type === "ScheduledShow"
      show = self.postable
      show.performers.each do |user|
        Notification.create! notification_type: :show_comment, source: show, user: user, send_to_chat: true, url: url
      end
    elsif self.postable_type === "ForumThread"
      Notification.create! notification_type: :new_thread_reply, source: self.postable, user: user, send_to_chat: true, send_to_user: false, url: url
    end
  end
end
