class BlogPostBody < ApplicationRecord
  belongs_to :blog_post
  enum language: [ :en, :ja, :kr ]
  validates :title, :body, presence: true
end
