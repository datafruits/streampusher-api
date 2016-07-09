##
# Backup v4.x Configuration
#
# Documentation: http://meskyanichi.github.io/backup
# Issue Tracker: https://github.com/meskyanichi/backup/issues

require 'yaml'
require 'dotenv'

# Get our environment variables
Dotenv.load

# Get the current Rails Environment, otherwise default to development
RAILS_ENV = ENV['RAILS_ENV'] || 'development'

# Load database.yml, including parsing any ERB it might
# contain. Remember if you're using Mongo, this should be
# mongoid.yml
DB_CONFIG = YAML.load(ERB.new(File.read(File.expand_path('../../config/database.yml',  __FILE__))).result)[RAILS_ENV]

# Set defaults for S3 which can be shared across multiple backup models
Storage::S3.defaults do |s3|
  s3.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  s3.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  s3.region            = "us-east-1"
end
