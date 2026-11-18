class WikiPageEdit < ApplicationRecord
  belongs_to :user
  belongs_to :wiki_page
  validates_presence_of :title, :body
  validates :summary, presence: true, if: :revising_existing_page?

  private

  def revising_existing_page?
    wiki_page&.wiki_page_edits&.where.not(id: id)&.exists?
  end
end
