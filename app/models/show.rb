class Show < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"

  validates_presence_of :start_at, :end_at

  def schedule_cannot_conflict
    self.radio.shows.where.not(id: id).each do |show|
      if end_at > show.start_at && start_at < show.end_at
        errors.add(:time, " conflict detected with show '#{show.user.username} - #{show.title}'. Please choose a different time.")
      end
    end
  end
end
