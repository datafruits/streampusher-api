class Chat
  def self.all_connections
    StreamPusher.redis.smembers "datafruits:chat:sockets"
  end

  def self.bans
    StreamPusher.redis.smembers "datafruits:chat:ips:banned"
  end

  def self.ban socket_id
    ip_address = socket_id.split(":")[1]
    StreamPusher.redis.sadd "datafruits:chat:ips:banned", ip_address
    StreamPusher.redis.publish "datafruits:chat:bans", socket_id
  end

  def self.unban ip_address
    StreamPusher.redis.srem "datafruits:chat:ips:banned", ip_address
  end
end
