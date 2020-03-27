class Chat
  def self.all_connections
    Redis.current.lrange "datafruits:chat:sockets", 0, -1
  end

  def self.ban socket_id
    ip_address = socket_id.split(":").last
    Redis.current.lpush "datafruits:chat:ips:banned", ip_address
    Redis.current.publish "datafruits:chat:bans", socket_id
  end

  def self.unban socket_id

  end
end
