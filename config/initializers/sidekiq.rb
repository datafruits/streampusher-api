host = ENV['REDIS_HOST'] || 'redis'
port = ENV['REDIS_PORT'] || 6379
password = ENV['REDIS_PASSWORD']

if ENV['CI']
  redis_url = "#{host}:#{port}"
else
  redis_url = "redis://#{host}:#{port}"
end
Sidekiq.configure_server do |config|
  config.redis = { url:  redis_url, password: password  }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  redis_url, password: password  }
end
