module User::Rpg
  extend ActiveSupport::Concern

  def xp_needed_for_next_level
    next_level - self.experience_points
  end

  def next_level
    if self.level === 0
      return 32
    elsif self.level === 1
      500
    else
      return 500 * (self.level ** 2) - (500 * self.level)
    end
  end

  def should_level_up?
    self.experience_points >= next_level
  end

  def level_up!
    self.level += 1
    self.save!
    Notification.create notification_type: "level_up", user: self, send_to_chat: true
    ActiveSupport::Notifications.instrument 'user.level_up', username: self.username, level: self.level
  end
end
