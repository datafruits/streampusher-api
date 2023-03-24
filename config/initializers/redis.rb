opts = {}
opts[:host] = ENV['REDIS_HOST'] || 'redis'
opts[:port] = ENV['REDIS_PORT'] || 6379
opts[:password] = ENV['REDIS_PASSWORD'] unless ENV['REDIS_PASSWORD'].nil?

Redis.current = Redis.new(**opts)
