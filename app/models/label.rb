class Label < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :radio_id }
  has_many :track_labels, dependent: :destroy
  has_many :tracks, through: :track_labels
  has_many :scheduled_show_labels, dependent: :destroy
  has_many :scheduled_shows, through: :scheduled_show_labels
  has_many :show_series_labels, dependent: :destroy
  has_many :show_series, through: :show_series_labels
  belongs_to :radio

  before_save :downcase_name

  private
  def downcase_name
    self.name.downcase!
  end
end
