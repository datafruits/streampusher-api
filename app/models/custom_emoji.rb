class CustomEmoji < ApplicationRecord
  belongs_to :user
  has_many :user_emojis
  has_many :users, through: :user_emojis
  has_one_attached :image

  validates :name, presence: true
  validate :user_can_create_emoji, on: :create

  private

  def user_can_create_emoji
    unless user&.can_create_custom_emoji?
      errors.add(:base, "You are not allowed to create more emojis (insufficient slots or missing DJ role)")
    end
  end
end
