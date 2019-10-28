host = ENV['REDIS_HOST'] || 'redis'
port = ENV['REDIS_PORT'] || 6379
password = ENV['REDIS_PASSWORD']

Sidekiq.configure_server do |config|
  if ENV['INSECURE_REDIS']
    config.redis = { url:  "redis://#{host}:#{port}"  }
  else
    config.redis = { url:  "redis://#{host}:#{port}", password: password  }
  end
end

Sidekiq.configure_client do |config|
  if ENV['INSECURE_REDIS']
    config.redis = { url:  "redis://#{host}:#{port}"  }
  else
    config.redis = { url:  "redis://#{host}:#{port}", password: password  }
  end
end
