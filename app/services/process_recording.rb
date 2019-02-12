require_relative '../../lib/sox'

class ProcessRecording
  def perform recording, scheduled_show: nil
    recording.update processing_status: 'processing'

    trimmed_file_path = Sox.trim recording.path

    radio = recording.radio
    s3_client = Aws::S3::Client.new
    bucket = ENV['S3_BUCKET']
    key = "#{radio.name}/#{File.basename(recording.path)}"
    content_type = "audio/mpeg"

    response = s3_client.put_object bucket: bucket, key: key,
      acl: "public-read",
      body: File.open(trimmed_file_path),
      content_type: content_type
    audio_file_name = "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{key}"
    track = radio.tracks.create audio_file_name: audio_file_name

    # if scheduled_show.present?
    #   # grab scheduled show's info to use metadata and artwork
    #   track.fill_metadata_from_show
    # end
    recording.update processing_status: 'processed', track: track
  end
end
