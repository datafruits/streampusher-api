class ExperiencePointAward < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  after_save :maybe_level_up
  after_save :send_notification

  enum award_type: [
    :chat_lurker, # lurking in chat TODO implement
    :music_enjoyer, # listening to stream or podcasts TODO implement???
    :textbox_like, # posting chats TODO implement???
    :uploaderzog, # uploading podcast
    :radio_enthusiast, # scheduling show
    :fruit_maniac, # clicking fruit buttons TODO implement???
    :streamingatron, # streaming live
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
  end
end
