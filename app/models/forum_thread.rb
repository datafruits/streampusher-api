class ForumThread < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true
  has_many :posts, as: :postable

  after_create :send_notification

  def save_new_thread! user, title, body
    self.title = title
    post = self.posts.new body: body
    post.user = user
    self.save! && post.save!
  end

  private
  def send_notification
    Notification.create! notification_type: "new_thread", source: self, send_to_chat: true, send_to_user: false, user: self.posts.first.user
  end
end
