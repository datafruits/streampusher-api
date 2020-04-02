class Chat
  def self.all_connections
    Redis.current.smembers "datafruits:chat:sockets"
  end

  def self.bans
    Redis.current.smembers "datafruits:chat:ips:banned"
  end

  def self.ban socket_id
    ip_address = socket_id.split(":").last
    Redis.current.sadd "datafruits:chat:ips:banned", ip_address
    Redis.current.publish "datafruits:chat:bans", socket_id
  end

  def self.unban socket_id
    ip_address = socket_id.split(":").last
    Redis.current.srem "datafruits:chat:ips:banned", ip_address
  end
end
