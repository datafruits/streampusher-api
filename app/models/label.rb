class Label < ActiveRecord::Base
  validates :name, presence: true
  has_many :track_labels, dependent: :destroy
  has_many :tracks, through: :track_labels
  belongs_to :radio
end
