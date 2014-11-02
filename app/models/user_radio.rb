class UserRadio < ActiveRecord::Base
  belongs_to :user
  belongs_to :radio
end
