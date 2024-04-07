class TrophyAward < ActiveRecord::Base
  belongs_to :user
  belongs_to :trophy
  belongs_to :shrimpo_entry
end
