class NextTrack
  # returns the filename of the next track to be played along with cue in/out and fade in/out lengths in seconds in a hash
  REQUEST_OFFSET = 10.seconds # liquidsoap requests a new track 10 seconds before the current is due to end, so try to account for this
  def self.perform radio
    now = Time.now
    current_scheduled_show = radio.current_scheduled_show now+REQUEST_OFFSET
    if current_scheduled_show
      radio.set_current_show_playing current_scheduled_show.id
      playlist = current_scheduled_show.playlist
      track_id = playlist.pop_next_track
      if track_id.blank?
        return { error: "No tracks!" }
      end
      track = Track.find track_id
      if playlist.no_cue_out?
        cue_out = 0
      else
        if (now+track.length.seconds) > current_scheduled_show.end_at
          cue_out = (current_scheduled_show.end_at-now).seconds
        else
          cue_out = 0
        end
      end
      # "annotate:liq_fade_in=\"0\",liq_fade_out=\"0\",liq_cue_in=\"0\",liq_cue_out=\"#{cue_out.to_i}\":#{track.file_basename}"
    else
      radio.set_current_show_playing nil
      playlist = radio.default_playlist
      track_id = playlist.pop_next_track
      if track_id.blank?
        return { error: "No tracks!" }
      end
      track = Track.find track_id
      next_scheduled_show = radio.next_scheduled_show now + REQUEST_OFFSET
      if playlist.no_cue_out?
        cue_out = 0
      else
        if next_scheduled_show && ((now+track.length.seconds) > next_scheduled_show.start_at)
          cue_out = (next_scheduled_show.start_at-now).seconds
        else
          # in this case we return 0 to indicate not to set the cue out,
          # just let the current track play out
          cue_out = 0
        end
      end
    end
    # liquidsoap's json parser wants strings
    { cue_out: cue_out.to_i.to_s, cue_in: 0.to_s, fade_out: 0.to_s, fade_in: 0.to_s, track: track.cdn_url }
  end
end
