require 'aws-sdk'

# S3 setup boilerplate
client = Aws::S3::Client.new(
  :region => 'us-east-1',
  :access_key_id => ENV['S3_KEY'],
  :secret_access_key => ENV['S3_SECRET'],
)
s3 = Aws::S3::Resource.new(:client => client)

bucket = s3.bucket('streampusher')

bucket.objects.each do |object_summary|
  puts object_summary.key
  if File.extname(object_summary.key) == ".mp3"
    puts "fixing metadata..."
    # Create our new metadata hash. This can be any hash; in this example we update
    # existing metadata with a new key-value pair.
    object = bucket.object(object_summary.key)
    new_metadata = object.metadata.merge('content-type' => 'audio/mpeg')

    # Use the copy operation to replace our metadata
      # IMPORTANT: normally S3 copies the metadata along with the object.
      # we must supply this directive to replace the existing metadata with
      # the values we supply
    object.copy_to(object, :metadata => new_metadata, :metadata_directive => "REPLACE", content_type: "audio/mpeg", acl: "public-read")
  end
end
