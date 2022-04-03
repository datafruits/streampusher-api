module RedisConnection
  def redis
    host = ENV['REDIS_HOST'] || 'redis'
    port = ENV['REDIS_PORT'] || 6379
    password = ENV['REDIS_PASSWORD']
    @redis ||= Redis.new(host: host, port: port, password: password)
  end
end
