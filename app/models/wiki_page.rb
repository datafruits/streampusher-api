class WikiPage < ApplicationRecord
  has_many :wiki_page_edits
  validates_presence_of :title, :body
end
