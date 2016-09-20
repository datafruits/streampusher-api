module ScheduledShowsHelper
  def multiple_timezones(time)
    timezones = {"PST" => "Pacific Time (US & Canada)",
                 "EST" => "Eastern Time (US & Canada)",
                 "UK"  => "London",
                 "EU"  => "Stockholm",
                 "日本"=> "Tokyo"}
    time_string = ""

    timezones.each do |k,v|
      time_string << "[#{Time.zone.parse(time.to_s).in_time_zone(v).strftime("%H:%M")} #{k}] "
    end

    time_string
  end

  def tweet_text(show)
    text = ""
    text << "#{show.title} on @datafruits #{show.start_at.strftime("%m/%d")} - #{multiple_timezones(show.start_at)}"
  end
end
