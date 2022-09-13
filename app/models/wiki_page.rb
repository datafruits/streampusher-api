class WikiPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :wiki_page_edits
  validates_presence_of :title, :body

  def save_new_edit! title, body, user_id
    edit = self.wiki_page_edits.new title: title, body: body, user_id: user_id
    edit.save!
    self.update! title: title, body: body
  end
end
