class StreamingExpAward
  def self.perform track
    if track.uploaded_by && track.length
      unless ExperiencePointAward.where(source_id: track.id).exists?
        ExperiencePointAward.create! user: track.uploaded_by, source_id: track.id, award_type: "streaming_streamer", amount: track.length / 30
      end
    end
  end
end
