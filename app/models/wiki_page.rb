class WikiPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :wiki_page_edits
  validates_presence_of :title, :body

  before_validation :update_slug, if: :title_changed?

  after_create :send_notification

  default_scope { where(deleted_at: nil) }

  def save_new_edit! params, user_id
    edit = self.wiki_page_edits.new params
    edit.user_id = user_id
    self.update! title: edit.title, body: edit.body
    edit.wiki_page = self
    edit.save!
  end

  def update_slug
    self.slug = nil
  end

  private
  def send_notification
    Notification.create notification_type: "new_wiki_page", source: self, send_to_chat: true, send_to_user: false
  end
end
