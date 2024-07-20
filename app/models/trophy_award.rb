class TrophyAward < ActiveRecord::Base
  belongs_to :user
  belongs_to :trophy
  belongs_to :shrimpo_entry

  after_create :send_notification

  private
  def send_notification
    Notification.create! source: self, notification_type: "shrimpo_trophy_award", user: self.user, send_to_chat: false
  end
end
