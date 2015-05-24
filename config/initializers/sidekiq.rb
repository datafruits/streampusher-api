Sidekiq.configure_server do |config|
  if !::Rails.env.production?
    if ENV['DOCKER_HOST'] # for CI
      config.redis = { url:  "redis://#{URI.parse(ENV['DOCKER_HOST']).hostname}" }
    end
  end
end

Sidekiq.configure_client do |config|
  if !::Rails.env.production?
    if ENV['DOCKER_HOST'] # for CI
      config.redis = { url:  "redis://#{URI.parse(ENV['DOCKER_HOST']).hostname}" }
    end
  end
end
