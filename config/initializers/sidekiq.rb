host = ENV['REDIS_HOST'] || 'redis'
port = ENV['REDIS_PORT'] || 6379
password = ENV['REDIS_PASSWORD']
redis_opts = {}

if ENV['CI']
  redis_opts[:url] = "#{host}:#{port}"
else
  redis_opts[:url] = "redis://#{host}:#{port}"
end

redis_opts[:password] = ENV['REDIS_PASSWORD'] unless ENV['REDIS_PASSWORD'].nil?

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end
