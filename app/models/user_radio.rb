class UserRadio < ActiveRecord::Base
  belongs_to :user
  belongs_to :radio
  validates_uniqueness_of :user_id, scope: :radio_id
end
