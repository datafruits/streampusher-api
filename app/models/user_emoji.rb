class UserEmoji < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validate :user_must_be_dj
  validate :user_must_have_emoji_slots_available

  private

  def user_must_be_dj
    errors.add(:base, "User must have the DJ role") unless user&.dj?
  end

  def user_must_have_emoji_slots_available
    return unless user&.dj?
    if user.user_emojis.where.not(id: id).size >= user.emoji_slots
      errors.add(:base, "No emoji slots available")
    end
  end
end
