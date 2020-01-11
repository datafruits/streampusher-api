require 'rails_helper'

RSpec.describe BlogPostBody, type: :model do
  it "delegates published and published_at to the blog_post" do
    radio = create :radio
    user = create :user
    blog_post = BlogPost.create radio: radio, user: user,
  end
end
