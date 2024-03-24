class Post < ApplicationRecord
  after_create :maybe_send_notification

  VALID_POSTABLE_TYPES = ['ForumThread', 'ScheduledShow', 'Shrimpo', 'ShrimpoEntry']
  belongs_to :postable, polymorphic: true, touch: true
  belongs_to :user

  def url
    if self.postable_type === "ScheduledShow"
      self.postable.url
    elsif self.postable_type === "ForumThread"
      "https://datafruits.fm/forum/#{self.postable.slug}"
    elsif self.postable_type === "Shrimpo"
      "https://datafruits.fm/shrimpos/#{self.postable.slug}"
    elsif self.postable_type === "ShrimpoEntry"
      "https://datafruits.fm/shrimpos/#{self.postable.shrimpo.slug}/entries/#{self.postable.slug}"
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
    elsif self.postable_type === "Shrimpo"
      Notification.create! notification_type: :shrimpo_comment, source: self.postable, user: self.postable.user, send_to_chat: true, send_to_user: false, url: url
    elsif self.postable_type === "ShrimpoEntry"
      Notification.create! notification_type: :shrimpo_entry_comment, source: self.postable, user: self.postable.user, send_to_chat: true, send_to_user: true, url: url
    end
  end
end
