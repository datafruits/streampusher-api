class WikiPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :wiki_page_edits
  validates_presence_of :title, :body

  before_validation :update_slug, if: :title_changed?

  default_scope { where(deleted_at: nil) }

  def save_new_edit! params, user_id
    transaction do
      edit = wiki_page_edits.new(params.merge(user_id: user_id))
      update!(title: edit.title, body: edit.body)
      edit.save!
    end
  end

  def update_slug
    self.slug = nil
  end
end
