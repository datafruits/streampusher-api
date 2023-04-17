class ExperiencePointAward < ApplicationRecord
  belongs_to :user

  after_save :maybe_level_up

  enum award_type: [
    :chat_lurker, # lurking in chat
    :music_enjoyer, # listening to stream or podcasts
    :textbox_poster, # posting chats
    :uploaderer, # uploading podcast
    :radio_enthusiast, # scheduling show
    :fruit_maniac, # clicking fruit buttons
    :streaming_streamer, # streaming live
  ]

  private
  def maybe_level_up
    self.user.update experience_points: self.amount
    while self.user.should_level_up?
      if self.user.should_level_up?
        self.user.level_up!
      end
    end
  end
end
