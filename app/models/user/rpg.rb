module User::Rpg
  extend ActiveSupport::Concern

  def next_level
    return 500 * (self.level ** 2) - (500 * self.level)
  end

  def should_level_up?
    self.experience_points >= next_level
  end

  def level_up!
    self.level += 1
    self.save!
  end
end
