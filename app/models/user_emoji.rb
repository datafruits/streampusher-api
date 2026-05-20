class UserEmoji < ApplicationRecord
  belongs_to :user
  belongs_to :custom_emoji
end
