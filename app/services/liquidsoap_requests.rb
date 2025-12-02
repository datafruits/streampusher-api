class LiquidsoapRequests
  def initialize radio_id, liquidsoap_socket_class=Liquidsoap::Socket
    @radio = Radio.find radio_id
    @liquidsoap_socket = liquidsoap_socket_class.new(@radio.liquidsoap_socket_path)
  end

  def alive
    @liquidsoap_socket.write("request.all").gsub(/END/, "").split(" ")
  end

  # FIXME this API no longer exists
  def on_air
    @liquidsoap_socket.write("request.on_air").gsub(/END/, "").split(" ")
  end

  def metadata rid
    @liquidsoap_socket.write("request.metadata #{rid}").force_encoding("UTF-8")
  end

  def request_metadatas requests
    requests.map {|r| self.metadata(r) }
  end

  # TODO
  # def on_air_filename
  #   on_air_rid = on_air radio
  #   metadata_line = metadata on_air_rid
  #   metadata_line.split("\n")
  #   uri_line = metadata_line.split("\n").select{ |m| m.include?("initial_uri")}.first
  #   return uri_line.split(",").select{ |m| m.include?("http") }.first.split(":").last(2).join(":")
  # end

  def add_to_queue uri
    @liquidsoap_socket.write("scheduled_shows.push #{uri}").encode("UTF-8")
  end

  def skip
    # @liquidsoap_socket.write("icecast.skip").encode("UTF-8")
    @liquidsoap_socket.write("backup_playlist.flush_and_skip").encode("UTF-8")
  end

  def scheduled_shows_queue
    queue = @liquidsoap_socket.write "scheduled_shows.queue"
    rids = queue.split(" ")[0..-2]

    metadatas = rids.map { |rid| self.metadata(rid) }
    metadatas.map {|m| self.metadata_to_hash(m) }
  end

  def metadata_to_hash m
    Hash[m.each_line.map { |line| line.chomp.gsub("\"", "").split("=", 2) }]
  end

  def current_source
    source = @liquidsoap_socket.write "fallback.current_source"
    if source.include?("live_dj")
      "live_dj"
    elsif source.include?("scheduled_shows")
      "scheduled_shows"
    elsif source.include?("backup_playlist")
      "backup_playlist"
    else
      "unknown"
    end
  end
end
