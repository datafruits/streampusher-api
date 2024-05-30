require 'rails_helper'

RSpec.describe ForumThread, type: :model do
  it 'saves new thread and post' do
    user = FactoryBot.create :user
    forum_thread = ForumThread.new
    forum_thread.save_new_thread! user, "test", "hey blahblahblahbalbhah"
    expect(forum_thread.persisted?).to eq true
    expect(forum_thread.title).to eq "test"
    expect(forum_thread.posts.count).to eq 1
    expect(forum_thread.posts.first.body).to eq "hey blahblahblahbalbhah"
    expect(forum_thread.posts.first.user).to eq user
  end

  # describe '.friendly_find' do
  #   thread = ForumThread.create! title: "can glorp do a glorp ?? ! "
  #   expect(ForumThread.friendly.find("can a glorp do a glorp ?? ! ")).to eq thread
  # end
end
