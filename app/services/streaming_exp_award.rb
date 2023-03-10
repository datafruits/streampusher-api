class StreamingExpAward
  def perform track
    if track.uploaded_by && track.length
      ExperiencePointAward.create user: track.uploaded_by, source_id: track.id, award_type: "streaming_streamer", amount: track.length # / 2 ???
    end
  end
end
