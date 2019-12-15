class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :radio
  has_many :blog_post_bodies
end
