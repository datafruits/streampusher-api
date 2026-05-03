class UserEmoji < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, presence: true
  validate :user_can_create_emoji, on: :create

  private

  def user_can_create_emoji
    unless user&.can_create_user_emoji?
      errors.add(:base, "You are not allowed to create more emojis (insufficient slots or missing DJ role)")
    end
  end
end
