class BlogPostBody < ApplicationRecord
  belongs_to :blog_post
  has_many :blog_post_images
  enum language: [ :en, :ja, :kr ]
  validates :title, :body, presence: true
  delegate :published_at, :published_at=, to: :blog_post

  before_save :save_blog_post

  scope :published, -> { where(published: true) }

  private
  def save_blog_post
    self.blog_post.save
  end
end
