class ScheduledShowExpAward
  def self.perform scheduled_show
    unless ExperiencePointAward.where(source_id: scheduled_show.id, user: scheduled_show.dj).exists? &&
        scheduled_show.playlist != scheduled_show.radio.default_playlist
      track = scheduled_show.playlist.tracks.first
      ExperiencePointAward.create! user: scheduled_show.dj, source_id: scheduled_show.id, award_type: "radio_enthusiast", amount: track.length / 60
    end
  end
end
