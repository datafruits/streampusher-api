def use_s3_for_paperclip
  Paperclip::Attachment.default_options.merge!({
    :storage => :s3,
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    bucket: ENV['S3_BUCKET']
  })
  yield
  Paperclip::Attachment.default_options.merge!({
    :storage => :filesystem
  })
end
