class Notification < ApplicatinoRecord
  after_create :send_notification

  belongs_to :user
  enum notification_type: [
    :strawberry_badge_award,
    :lemon_badge_award,
    :orange_award,
    :banana_award,
    :cabbage_award,
    :watermelon_award,
    :level_up,
  ]

  private
  def send_notification
    if self.send_to_chat?
      # TODO
      # send to chat
    end

    if self.send_to_user?
      # TODO
      # send to user's inbox
    end
  end
end
