class ScheduledShowPerformer < ActiveRecord::Base
  belongs_to :user
  belongs_to :scheduled_show
  validates :user, uniqueness: { scope: :scheduled_show, message: "You can't assign the same user multiple times to the same scheduled show" }
end
