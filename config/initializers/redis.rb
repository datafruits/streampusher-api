host = ENV['REDIS_HOST'] || 'redis'
port = ENV['REDIS_PORT'] || 6379
password = ENV['REDIS_PASSWORD']

Redis.current = Redis.new host: host, port: port, password: password
