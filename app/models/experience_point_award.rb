class ExperiencePointAward < ApplicationRecord
  belongs_to :user

  enum award_type: [
    :chat_lurker, # lurking in chat
    :music_enjoyer, # listening to stream or podcasts
    :textbox_poster, # posting chats
    :uploader, # uploading podcast
    :radio_enthusiast, # scheduling show
    :fruit_maniac, # clicking fruit buttons
  ]
end
