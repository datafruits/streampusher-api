host = ENV['REDIS_HOST'] || 'localhost'
port = ENV['REDIS_PORT'] || 6379

Sidekiq.configure_server do |config|
  config.redis = { url:  "redis://#{host}:#{port}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  "redis://#{host}:#{port}" }
end
