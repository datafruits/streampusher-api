class WikiPageEdit < ApplicationRecord
  belongs_to :user
  belongs_to :wiki_page
end
