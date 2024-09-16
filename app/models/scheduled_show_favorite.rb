class ScheduledShowFavorite < ActiveRecord::Base
  belongs_to :scheduled_show
  belongs_to :user
end
