class ScheduledShowLabel < ActiveRecord::Base
  belongs_to :label
  belongs_to :scheduled_show
end
