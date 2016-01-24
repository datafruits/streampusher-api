class NextTrack
  # returns the filename of the next track to be played along with cue in/out and fade in/out lengths in seconds in a hash
  REQUEST_OFFSET = 10.seconds # liquidsoap requests a new track 10 seconds before the current is due to end, so try to account for this
  def self.perform radio
    now = Time.now
    current_scheduled_show = radio.current_scheduled_show now
    if current_scheduled_show
      playlist = current_scheduled_show.show.playlist
      track_id = playlist.pop_next_track
      if track_id.blank?
        return { error: "No tracks!" }
      end
      track = Track.find track_id
      if (now+track.length.seconds) > current_scheduled_show.end_at
        cue_out = (current_scheduled_show.end_at-now).seconds
        if cue_out > 10
          cue_out = cue_out - REQUEST_OFFSET
        end
      else
        cue_out = track.length.seconds
      end
      # "annotate:liq_fade_in=\"0\",liq_fade_out=\"0\",liq_cue_in=\"0\",liq_cue_out=\"#{cue_out.to_i}\":#{track.file_basename}"
    else
      playlist = radio.default_playlist
      track_id = playlist.pop_next_track
      if track_id.blank?
        return { error: "No tracks!" }
      end
      track = Track.find track_id
      next_scheduled_show = radio.next_scheduled_show now
      if next_scheduled_show && ((now+track.length.seconds) > next_scheduled_show.start_at)
        cue_out = (next_scheduled_show.start_at-now).seconds
        if cue_out > 10
          cue_out = cue_out - REQUEST_OFFSET
        end
      else
        cue_out = track.length.seconds
      end
    end
    # liquidsoap's json parser wants strings
    { cue_out: cue_out.to_i.to_s, cue_in: 0.to_s, fade_out: 0.to_s, fade_in: 0.to_s, track: track.file_basename }
  end
end
