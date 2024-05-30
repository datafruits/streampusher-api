class ShowSeriesHost < ApplicationRecord
  belongs_to :user
  belongs_to :show_series
  validates :user, presence: true, uniqueness: { scope: :show_series, message: "You can't assign the same user multiple times to the same show series" }
end
