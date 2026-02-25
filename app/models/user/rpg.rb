module User::Rpg
  extend ActiveSupport::Concern

  def xp_needed_for_next_level
    next_level - self.experience_points
  end

  def xp_required_for_level(level)
    if level == 0
      32
    elsif level == 1
      500
    else
      500 * (level ** 2) - (500 * level)
    end
  end

  def next_level
    return xp_required_for_level(self.level)
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

  def xp_progress_percentage
    (self.experience_points.to_f / self.next_level) * 100
  end
end
