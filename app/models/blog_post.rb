class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :radio
  has_many :blog_post_bodies

  scope :published, -> { joins(:blog_post_bodies).where(blog_post_bodies: { published: true}) }
end

