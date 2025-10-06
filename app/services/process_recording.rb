class ProcessRecording
  def perform recording, scheduled_show= nil
    recording.update processing_status: 'processing'

    begin
      # Check if this recording already has a track to prevent duplicates
      if recording.track.present?
        Rails.logger.info "Recording #{recording.id} already has track #{recording.track.id}, skipping processing"
        recording.update processing_status: 'processed'
        return recording.track
      end

      trimmed_file_path = Sox.trim recording.path

      radio = recording.radio
      credentials = Aws::Credentials.new ENV['S3_KEY'], ENV['S3_SECRET']
      s3_client = Aws::S3::Client.new credentials: credentials
      bucket = ENV['S3_BUCKET']
      basename = File.basename(recording.path)
      key = "#{radio.name}/#{basename}"
      content_type = "audio/mpeg"

      response = s3_client.put_object bucket: bucket, key: key,
        acl: "public-read",
        body: File.open(trimmed_file_path),
        content_type: content_type
      audio_file_name = "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{key}"

      # Check for existing track with same audio file for same scheduled show to prevent duplicates
      if scheduled_show.present?
        track = nil
        existing_track = scheduled_show.tracks.find_by(audio_file_name: audio_file_name)
        if existing_track.present?
          Rails.logger.info "Track with audio file #{audio_file_name} already exists for scheduled show #{scheduled_show.id}"
          track = existing_track
        else
          username = basename.split("datafruits-").last.split("-").first
          user = User.find_by(username: username)
          track = radio.tracks.create! audio_file_name: audio_file_name, uploaded_by: user
        end

        # grab scheduled show's info to use metadata and artwork
        track.update scheduled_show_id: scheduled_show.id, title: scheduled_show.formatted_episode_title

      else
        username = basename.split("datafruits-").last.split("-").first
        user = User.find_by(username: username)
        track = radio.tracks.create! audio_file_name: audio_file_name, uploaded_by: user
      end

      recording.update processing_status: 'processed', track: track

      StreamingExpAwardWorker.set(wait: 15.minute).perform_later(track.id)
    rescue Exception => e
      recording.update processing_status: 'processing_failed'
      raise e
    end
    recording.update processing_status: 'processed', track: track
  end
end
