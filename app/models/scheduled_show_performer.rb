class ScheduledShowPerformer < ActiveRecord::Base
  belongs_to :user
  belongs_to :scheduled_show
end
