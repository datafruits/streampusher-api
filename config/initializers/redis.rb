module StreamPusher
  def self.redis
    opts = {}
    opts[:host] = ENV['REDIS_HOST'] || 'redis'
    opts[:port] = ENV['REDIS_PORT'] || 6379
    opts[:password] = ENV['REDIS_PASSWORD'] unless ENV['REDIS_PASSWORD'].nil?

    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new(**opts)
    end
  end
end
