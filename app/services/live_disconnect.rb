class LiveDisconnect
  def self.perform radio
    r = Radio.find_by name: radio
    s = r.current_scheduled_show
    # TODO what if they disconnected early??
    if s.present?
      current_show = { title: s.title, user: s.dj.username }
      current_show[:scheduled_show] = s.id
      ::StreamPusher.redis.hset "#{radio}:current_show", current_show
    else
      # current_show = { title: "", user: "", scheduled_show: "" }
      ::StreamPusher.redis.hdel "#{radio}:current_show", "title"
      ::StreamPusher.redis.hdel "#{radio}:current_show", "user"
      ::StreamPusher.redis.hdel "#{radio}:current_show", "scheduled_show"
    end
  end
end
