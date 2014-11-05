class Show < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
end
