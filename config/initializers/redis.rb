if ::Rails.env.production?
  Redis.current = Redis.new
else
  Redis.current = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname
end
