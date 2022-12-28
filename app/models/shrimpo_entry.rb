class ShrimpoEntry < ApplicationRecord
  belongs_to :shrimpo
  belongs_to :user

  validates :title, presence: true

  has_one_attached :audio
end
