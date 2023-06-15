class StreamingExpAward
  def self.perform track, show
    # TODO should award hosts of show not just track uploader
    if track.uploaded_by && track.length
      show.performers.each do |user|
        unless ExperiencePointAward.where(source_id: track.id, user: user).exists?
          ExperiencePointAward.create! user: user, source_id: track.id, award_type: "streamingatron", amount: track.length / 30
          ActiveSupport::Notifications.instrument 'user.xp_award', username: track.uploaded_by.username, award_type: "streamingatron", amount: track.length / 30
        end
      end
    end
  end
end
