source 'https://rubygems.org/'

gem 'rails', '7.0.5'
gem 'pg'

gem 'spring',        group: :development

gem 'devise'
gem 'devise-jwt'
gem 'warden-jwt_auth', github: "waiting-for-dev/warden-jwt_auth"
gem 'omniauth'
#gem 'omniauth-soundcloud', github: "mcfiredrill/omniauth-soundcloud"
#gem 'omniauth-mixcloud', github: "streampusher/omniauth-mixcloud"
# gem 'mixcloud', github: 'streampusher/mixcloud-ruby'
# gem 'soundcloud'
gem 'cancancan'
gem 'docker-api', '~> 2.2.0', require: 'docker'
gem 'terrapin'
gem 'lograge'
gem 'rack-cors', :require => 'rack/cors'

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'rspec-rails', '~> 3.5.2', :group => [:development, :test]

gem 'redis'
gem 'connection_pool'

gem 'dotenv-rails'
gem 'unicorn'

gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-bundler'
gem 'capistrano-rbenv', "~>2.0"
gem 'capistrano-nvm', require: false
gem 'capistrano-sidekiq'
gem 'capistrano-cookbook', require: false, group: :development

group :test do
  gem 'factory_bot_rails'
  gem 'vcr'
  gem 'webmock'
  gem 'mock_redis'
  gem 'timecop'
  gem 'capybara'
  gem 'database_rewinder'
  gem 'selenium-webdriver', '< 3.0'
  gem 'headless'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'tzinfo-data'
end

group :development do
  gem 'bullet'
  gem "ruby-lsp", require: false
end

group :production do
  gem 'remote_syslog_logger'
end

gem 'byebug'
gem 'slackistrano', require: false
gem 'httparty'
gem 'exception_notification', github: "mcfiredrill/exception_notification"

gem 'acts_as_list'
gem 'kaminari'
gem 'active_model_serializers', '~> 0.10.0'
gem 'jsonapi-serializer'
gem 'chronic'
gem 'aws-sdk'
gem "kt-paperclip", "~> 6.4", ">= 6.4.1"
gem "image_processing", ">= 1.2"

gem 'rupeepeethree', github: "datafruits/rupeepeethree"
gem "so_id3", github: "streampusher/so_id3", branch: "fix-artwork-download-https"

gem 'whenever', require: false

gem 'recurrence'

gem 'ruby-liquidsoap', github: 'streampusher/ruby-liquidsoap', :require => 'liquidsoap'

gem 'friendly_id'

gem 'discord-notifier'
gem 'slack-notifier'

gem 'patreon'

# gem 'bootsnap', require: false
gem 'thwait'
gem 'e2mmap'

gem 'rack-mini-profiler'

gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false

gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

gem "skylight"

gem "rubyzip"
