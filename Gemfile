source 'https://rubygems.org/'

gem 'rails', '5.2.7'
gem 'pg'

gem 'spring',        group: :development

gem 'devise'
gem 'devise-jwt'
gem 'warden-jwt_auth', github: "waiting-for-dev/warden-jwt_auth"
gem 'omniauth'
gem 'omniauth-soundcloud', github: "mcfiredrill/omniauth-soundcloud"
gem 'omniauth-mixcloud', github: "streampusher/omniauth-mixcloud"
gem 'mixcloud', github: 'streampusher/mixcloud-ruby'
gem 'soundcloud'
gem 'omniauth-tumblr'
gem 'tumblr_client'
gem 'cancancan'
gem 'docker-api', '~> 1.22.4', require: 'docker'
gem 'terrapin'
gem 'lograge'
gem 'rack-cors', :require => 'rack/cors'

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'execjs'
gem 'therubyracer'
gem 'rspec-rails', '~> 3.5.2', :group => [:development, :test]

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

group :production do
  gem 'remote_syslog_logger'
end

gem 'byebug'
gem 'slackistrano', require: false
gem 'httparty'
gem 'exception_notification'

gem 'groupdate'
gem 'acts_as_list'
gem 'kaminari'
gem 'active_model_serializers', '~> 0.10.0'
gem 'chronic'
gem 'aws-sdk'
gem 'paperclip'

gem 'rupeepeethree', github: "datafruits/rupeepeethree"
gem "so_id3", github: "streampusher/so_id3"

gem 'whenever', require: false

gem 'recurrence'

gem 'html-pipeline'
gem 'commonmarker'
gem 'github-markdown'

gem 'geocoder'
gem 'ruby-liquidsoap', github: 'streampusher/ruby-liquidsoap', :require => 'liquidsoap'
gem 'paper_trail'

gem 'friendly_id'

gem 'discord-notifier'

# gem 'bootsnap', require: false
gem 'thwait'
gem 'e2mmap'
