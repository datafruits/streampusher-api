class UserAccessory < ApplicationRecord
  belongs_to :accessory
  belongs_to :user
end
