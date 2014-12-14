S3DirectUpload.config do |c|
  c.access_key_id = ENV['S3_KEY']       # your access key id
  c.secret_access_key = ENV['S3_SECRET']   # your secret access key
  c.bucket = "streampusher"              # your bucket name
  # c.region = nil             # region prefix of your bucket url. This is _required_ for the non-default AWS region, eg. "s3-eu-west-1"
  # c.url = nil                # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
end

