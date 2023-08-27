class Shrimpo < ApplicationRecord
  belongs_to :user
  has_many :shrimpo_entries

  has_one_attached :zip

  validates :title, presence: true

  enum status: [:running, :voting, :completed]
end
