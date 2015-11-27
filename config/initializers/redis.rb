if ::Rails.env.production?
  Redis.current = Redis.new
else
  #if ENV['DOCKER_HOST']
  #  Redis.current = Redis.new host: URI.parse(ENV['DOCKER_HOST']).hostname
  #else
    # for CI
    Redis.current = Redis.new
  #end
end
