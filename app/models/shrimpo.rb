class Shrimpo < ApplicationRecord
  belongs_to :user

  has_one_attached :zip

  validates :title, presence: true
end
