class Notification < ApplicatinoRecord
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

  private
  def send_notification
    if self.send_to_chat?
      # TODO
      # send to chat
      #
      redis.publish "datafruits:user_notifications", self.to_json
    end
  end
end
