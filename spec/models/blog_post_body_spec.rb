require 'rails_helper'

RSpec.describe BlogPostBody, type: :model do
  it "delegates published_at to the blog_post" do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user
    blog_post = BlogPost.create radio: radio, user: user
    blog_post_body = blog_post.blog_post_bodies.create title: "test", body: "asdf"
    date = Time.now
    blog_post_body.update published: true, published_at: date
    blog_post_body.save
    blog_post.reload
    expect(blog_post_body.published).to eq true
    expect(blog_post.published_at).to_not eq nil
  end
end
