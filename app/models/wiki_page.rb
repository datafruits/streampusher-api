class WikiPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :wiki_page_edits
  validates_presence_of :title, :body
end
