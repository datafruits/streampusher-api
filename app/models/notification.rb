class Notification < ApplicationRecord
  include RedisConnection

  after_create :send_notification
  before_save :set_message

  belongs_to :user
  belongs_to :source, polymorphic: true

  enum notification_type: [
    :strawberry_badge_award,
    :lemon_badge_award,
    :orange_badge_award,
    :banana_badge_award,
    :cabbage_badge_award,
    :watermelon_badge_award,
    :pineapple_badge_award,
    :limer_badge_award,
    :dj_badge_award,
    :vj_badge_award,
    :supporter_badge_award,
    :level_up,
    :experience_point_award,
    :fruit_ticket_gift,
    :supporter_fruit_ticket_stipend,
    :glorp_lottery_winner
  ]

  private
  def set_message
    self.message = case self.notification_type
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
    when "pineapple_badge_award"
      "#{self.user.username} got the pineapplee badge!"
    when "limer_badge_award"
      "#{self.user.username} got the limer badge!"
    when "dragionfruit badge_award"
      "#{self.user.username} got the dragionfruit badge!"
    when "blueberrinies badge_award"
      "#{self.user.username} got the blueberrinies badge!"
    when "beamsprout_badge_award"
      "#{self.user.username} got the beamsprout badge!"
    when "dj_badge_award"
      "#{self.user.username} got the DJ badge!"
    when "vj_badge_award"
      "#{self.user.username} got the VJ badge!"
    when "supporter_badge_award"
      "#{self.user.username} got the supporter badge!"
    when "level_up"
      "#{self.user.username} reached level #{self.user.level}!"
    when "experience_point_award"
      "You got #{self.source.amount} #{self.source.award_type} points!"
    when "fruit_ticket_gift"
      "#{self.source.from_user.username} sent you Ƒ#{self.source.amount} fruit tickets!"
    when "supporter_fruit_ticket_stipend"
      "You got Ƒ#{self.source.amount} fruit tickets for supporting datafruits. The bank of fruit tickets thanks you for your support!"
    when "glorp_lottery_winner"
      ":#{self.source.award_type.split("py").first}:!!! #{self.user.username} got #{self.source.amount} #{self.source.award_type} points!"
    end
  end

  def send_notification
    if self.send_to_chat?
      redis.publish "datafruits:user_notifications", self.message
    end
  end
end
