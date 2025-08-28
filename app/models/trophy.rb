class Trophy < ActiveRecord::Base
  has_one_attached :image
  has_one_attached :model
  has_one :shrimpo_voting_category
end
