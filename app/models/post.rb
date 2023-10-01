class Post < ApplicationRecord
  VALID_POSTABLE_TYPES = ['ForumThread', 'ScheduledShow']
  belongs_to :postable, polymorphic: true, touch: true
  belongs_to :user
end
