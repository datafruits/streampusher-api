class Notification < ApplicationRecord
  include RedisConnection

  after_create :send_notification

  belongs_to :user
  enum notification_type: [
    :strawberry_badge_award,
    :lemon_badge_award,
    :orange_badge_award,
    :banana_badge_award,
    :cabbage_badge_award,
    :watermelon_badge_award,
    :level_up,
    :experience_point_award
  ]

  def message
    case self.notification_type
    when "strawberry_badge_award"
      "#{self.user.username} got the strawbur badge!"
    when "lemon_badge_award"
      "#{self.user.username} got the lemoner badge!"
    when "orange_badge_award"
      "#{self.user.username} got the orangey badge!"
    when "banana_badge_award"
      "#{self.user.username} got the banaynay badge!"
    when "cabbage_badge_award"
      "#{self.user.username} got the evil cabbage badge!"
    when "watermelon_badge_award"
      "#{self.user.username} got the watermel badge!"
    when "level_up"
      "#{self.user.username} reached level #{self.user.level}!"
    when "experience_point_award"
      "You got #{self.source.amount} #{self.source.award_type} points!"
    end
  end

  private
  def send_notification
    if self.send_to_chat?
      # TODO
      # send to chat
      #
      redis.publish "datafruits:user_notifications", self.message
    end
  end
end
