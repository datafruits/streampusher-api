require 'net/http'
require 'uri'

class CollectStats
  ICECAST_URL = "#{ENV['ICECAST_STATS_HOST']}/admin/listmounts?with_listeners"
  def initialize radio
    @redis = Redis.current
    @radio = radio
  end

  def perform
    current_connected_ids = []

    icecast_xml = download_icecast_xml
    doc = Nokogiri::HTML(download_icecast_xml)
    doc.xpath("//source[@mount=\"/#{@radio.name}.mp3\"]/listener").each do |listener|
      # ip = listener.xpath("//ip").text
      ip = listener.children.select{|n| n.name.downcase == "ip"}.first.text
      icecast_listener_id = listener.children.select{|n| n.name.downcase == "id"}.first.text.to_i
      user_agent = listener.children.select{|n| n.name.downcase == "useragent"}.first.text
      referer = listener.children.select{|n| n.name.downcase == "referer"}.first.try(:text)
      current_connected_ids << icecast_listener_id
      # store current listeners in redis
      # {id: 3, start_at:}
      unless is_connected? icecast_listener_id
        start_at = Time.now
        Listen.create radio: @radio, ip_address: ip, icecast_listener_id: icecast_listener_id, start_at: start_at, user_agent: user_agent, referer: referer
        @redis.hset @radio.listeners_key, icecast_listener_id, start_at
      end
    end
    end_at = Time.now
    @redis.hgetall(@radio.listeners_key).each do |id, start_at|
      unless current_connected_ids.include? id.to_i
        listen = @radio.listens.find_by(icecast_listener_id: id.to_i)
        if listen
          listen.update end_at: end_at
        end
        @redis.hdel @radio.listeners_key, id
      end
    end
  end

  private
  def download_icecast_xml
    uri = URI.parse ICECAST_URL

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.port == 443
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth("admin", "hackme")
    response = http.request(request)
    response.body
  end

  def is_connected? id
    listen = @redis.hget @radio.listeners_key, id
    !listen.blank?
  end
end
