Paperclip::Attachment.default_options.merge!({
  storage: :s3,
  s3_credentials: {
    access_key_id: ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET'],
    s3_region: ENV['S3_REGION']
  },
  s3_protocol: :https,
  bucket: ENV['S3_BUCKET'],
  path: ":attachment/:style/:basename.:extension",
  url: ':s3_alias_url',
  s3_host_alias: ENV['CLOUDFRONT_URL']
})
