class Post < ApplicationRecord
  VALID_POSTABLE_TYPES = ['ForumThread']
  belongs_to :postable, polymorphic: true
  belongs_to :user
end
