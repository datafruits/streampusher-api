module ScheduledShowsHelper
  def tweet_text(show)
    text = ""
    text << "#{show.title} on #{show.radio.name} "
    text << timezones_text(show)
    text
  end

  def timezones_text show
    text = ""
    last_date = ""
    multiple_timezones(show.start_at).each_with_index do |timezone, index|
      date = timezone.last[:date]
      time = timezone.last[:time]
      if date != last_date
        time_text = "#{date} - #{time} #{timezone.first}"
      else
        time_text = "#{time} #{timezone.first}"
      end
      unless index == 0
        text << " - "
      end
      text << "#{time_text}"
      last_date = date
    end
    text
  end

  private
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

end
