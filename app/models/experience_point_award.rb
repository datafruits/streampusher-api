class ExperiencePointAward < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  after_save :maybe_level_up
  after_save :send_notification

  validates :amount,
    numericality: { only_integer: true, greater_than: 0 }

  enum award_type: [
    :chat_lurker, # lurking in chat TODO implement
    :music_enjoyer, # listening to stream or podcasts TODO implement???
    :textbox_like, # posting chats TODO implement???
    :uploaderzog, # uploading podcast
    :radio_enthusiast, # scheduling show
    :fruit_maniac, # clicking fruit buttons TODO implement???
    :streamingatron, # streaming live
    :glorppy, # daily glorp lottery
    :gloppy, # daily glop lottery
    :shrimpo, # winning shrimpo
    :shrimpo_appreciator, # voting shrimpo
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
    if self.award_type === "glorppy" || self.award_type === "gloppy"
      Notification.create! source: self, notification_type: "glorp_lottery_winner", user: self.user, send_to_chat: true, send_to_user: false
    end
    ActiveSupport::Notifications.instrument 'user.xp_award', username: self.user.username, award_type: self.award_type, amount: self.amount
  end
end
