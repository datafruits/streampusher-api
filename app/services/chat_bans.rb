class Chat
  def all_connections
    Redis.current.lindex "datafruits:chat:sockets", 0, -1
  end

  def ban socket_id
    ip_address = socket_id.split(":").last
    Redis.current.lpush "datafruits:chat:ips:banned", ip_address
    Redis.current.publish "datafruits:chat:bans", socket_id
  end
end
