host = ENV['REDIS_PORT_6379_TCP_ADDR'] || 'localhost'
port = ENV['REDIS_PORT_6379_TCP_PORT'] || 6379

Sidekiq.configure_server do |config|
  config.redis = { url:  "redis://#{host}:#{port}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  "redis://#{host}:#{port}" }
end
