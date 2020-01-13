require 'rails_helper'

RSpec.describe BlogPostBody, type: :model do
  it "delegates published and published_at to the blog_post" do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user
    blog_post = BlogPost.create radio: radio, user: user
    blog_post_body = blog_post.blog_post_bodies.create title: "test"
    date = Time.now
    blog_post_body.update published: true, published_at: date
    expect(blog_post.published).to eq true
    expect(blog_post.published_at).to eq date
  end
end
