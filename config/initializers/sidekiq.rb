Sidekiq.configure_server do |config|
  if !::Rails.env.production?
    config.redis = { url:  "redis://#{URI.parse(ENV['DOCKER_HOST']).hostname}" }
  end
end

Sidekiq.configure_client do |config|
  if !::Rails.env.production?
    config.redis = { url:  "redis://#{URI.parse(ENV['DOCKER_HOST']).hostname}" }
  end
end
