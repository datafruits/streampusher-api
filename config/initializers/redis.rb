host = ENV['REDIS_PORT_6379_TCP_ADDR'] || 'redis'
port = ENV['REDIS_PORT_6379_TCP_PORT'] || 6379
password = ENV['REDIS_PASSWORD']
Redis.current = Redis.new host: host, port: port, password: password
