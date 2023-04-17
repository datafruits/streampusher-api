class ProcessRecording
  def perform recording, scheduled_show: nil
    recording.update processing_status: 'processing'

    begin
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
      username = basename.split("datafruits-").last.split("-").first
      user = User.find_by(username: username)
      track = radio.tracks.create! audio_file_name: audio_file_name, uploaded_by: user
      StreamingExpAwardWorker.set(wait: 1.minute).perform_later(track.id)

      # if scheduled_show.present?
      #   # grab scheduled show's info to use metadata and artwork
      #   track.fill_metadata_from_show
      # end
    rescue Exception => e
      recording.update processing_status: 'processing_failed'
      raise e
    end
    recording.update processing_status: 'processed', track: track
  end
end
