class WikiPageEdit < ApplicationRecord
  belongs_to :user
  belongs_to :wiki_page
  validates_presence_of :title, :body
  after_create :send_notification

  private
  def send_notification
    Notification.create notification_type: "wiki_page_update", source: self, send_to_chat: true, send_to_user: false
  end
end
