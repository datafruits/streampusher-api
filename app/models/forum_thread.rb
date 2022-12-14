class ForumThread < ApplicationRecord
  has_many :posts, as: :postable
end
