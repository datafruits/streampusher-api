class BlogPostBody < ApplicationRecord
  belongs_to :blog_post
  has_many :blog_post_images
  enum language: [ :en, :ja, :kr ]
  validates :title, :body, presence: true
end
