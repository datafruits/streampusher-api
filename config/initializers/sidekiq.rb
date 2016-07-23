host = ENV['REDIS_PORT_6379_TCP_ADDR'] || 'redis'
port = ENV['REDIS_PORT_6379_TCP_PORT'] || 6379
password = ENV['REDIS_PASSWORD']

Sidekiq.configure_server do |config|
  config.redis = { url:  "redis://#{host}:#{port}", password: password  }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  "redis://#{host}:#{port}", password: password }
end
