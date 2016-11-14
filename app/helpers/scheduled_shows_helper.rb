module ScheduledShowsHelper
  def multiple_timezones(time)
    timezones = {"PST" => "Pacific Time (US & Canada)",
                 "EST" => "Eastern Time (US & Canada)",
                 "UK"  => "London",
                 "日本"=> "Tokyo"}
    times_hash = {}

    timezones.each do |k,v|
      local_time = Time.zone.parse(time.to_s).in_time_zone(v).strftime("%H:%M")
      date = Time.zone.parse(time.to_s).in_time_zone(v).strftime("%m/%d")
      times_hash[k] = { :time => local_time, :date => date }
    end

    times_hash
  end

  def tweet_text(show)
    text = ""
    last_date = ""
    text << "#{show.title} on #{show.radio.name}"
    multiple_timezones(show.start_at).each do |k, v|
      date = v[:date]
      time = v[:time]
      if date != last_date
        time_text = "#{date} - #{time} #{k}"
      else
        time_text = "#{time} #{k}"
      end
      text << " - #{time_text}"
      last_date = date
    end
    text
  end
end
