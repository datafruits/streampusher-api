class WikiPageEdit < ApplicationRecord
  belongs_to :user
  belongs_to :wiki_page
  validates_presence_of :title, :body
end
