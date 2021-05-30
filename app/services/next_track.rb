class NextTrack
  # returns the filename of the next track to be played from the default playlist
  # along with cue in/out and fade in/out lengths in seconds in a hash
  def self.perform radio
    playlist = radio.default_playlist
    track_id = playlist.pop_next_track
    if track_id.blank?
      return { error: "No tracks!" }
    end
    track = Track.find track_id
    # liquidsoap's json parser wants strings
    { cue_out: 0.to_i.to_s, cue_in: 0.to_s, fade_out: 0.to_s, fade_in: 0.to_s, track: track.s3_filepath }
  end
end
