host = ENV['REDIS_HOST'] || 'localhost'
port = ENV['REDIS_PORT'] || 6379
Redis.current = Redis.new host: host, port: port
