class Trophy < ActiveRecord::Base
  has_one_attached :image
  has_one_attached :model
end
