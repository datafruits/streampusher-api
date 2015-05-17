class ScheduledShow < ActiveRecord::Base
  belongs_to :radio
  belongs_to :show

  validates_presence_of :start_at, :end_at
  validates_presence_of :show_id

  alias_attribute :start, :start_at
  alias_attribute :end, :end_at

  def title
    self.show.title
  end

  def schedule_cannot_conflict
    self.radio.scheduled_shows.where.not(id: id).each do |show|
      if end_at > show.start_at && start_at < show.end_at
        errors.add(:time, " conflict detected with show '#{show.user.username} - #{show.title}'. Please choose a different time.")
      end
    end
  end
end
