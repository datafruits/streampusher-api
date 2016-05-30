host = ENV['REDIS_PORT_6379_TCP_ADDR'] || 'localhost'
port = ENV['REDIS_PORT_6379_TCP_PORT'] || 6379
Redis.current = Redis.new host: host, port: port
