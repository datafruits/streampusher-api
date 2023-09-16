class ExperiencePointAward < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  after_save :maybe_level_up
  after_save :send_notification

  enum award_type: [
    :chat_lurker, # lurking in chat
    :music_enjoyer, # listening to stream or podcasts
    :textbox_like, # posting chats
    :uploaderzog, # uploading podcast
    :radio_enthusiast, # scheduling show
    :fruit_maniac, # clicking fruit buttons
    :streamingatron, # streaming live
    :glorppy, # daily glorp lottery
    :gloppy, # daily glop lottery
  ]

  private
  def maybe_level_up
    xp = self.amount + self.user.experience_points
    self.user.update experience_points: xp
    while self.user.should_level_up?
      if self.user.should_level_up?
        self.user.level_up!
      end
    end
  end

  def send_notification
    Notification.create! source: self, notification_type: "experience_point_award", user: self.user, send_to_chat: false
    if self.award_type === "glorpy" || self.award_type === "gloppy"
      Notification.create! source: self, notification_type: "glorp_lottery_winner", user: self.user, send_to_chat: true, send_to_user: false
    end
  end
end
