class StreamingExpAward
  def self.perform track
    if track.uploaded_by && track.length
      if track.scheduled_show.present?
        track.scheduled_show.performers.each do |user|
          unless ExperiencePointAward.where(source_id: track.id, user: user).exists?
            ExperiencePointAward.create! user: user, source_id: track.id, award_type: "streamingatron", amount: track.length / 30
            ActiveSupport::Notifications.instrument 'user.xp_award', username: user.username, award_type: "streamingatron", amount: track.length / 30
          end
        end
      else
        unless ExperiencePointAward.where(source_id: track.id, user: track.uploaded_by).exists?
          ExperiencePointAward.create! user: track.uploaded_by, source_id: track.id, award_type: "streamingatron", amount: track.length / 30
          ActiveSupport::Notifications.instrument 'user.xp_award', username: track.uploaded_by.username, award_type: "streamingatron", amount: track.length / 30
        end
      end
    end
  end
end
