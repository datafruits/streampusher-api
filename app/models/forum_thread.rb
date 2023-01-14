class ForumThread < ApplicationRecord
  validates :title, presence: true
  has_many :posts, as: :postable

  def save_new_thread! user, title, body
    self.title = title
    post = self.posts.new body: body
    post.user = user
    self.save! && post.save!
  end
end
