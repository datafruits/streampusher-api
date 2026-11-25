module ShowsHelper
  include WikiPagesHelper

  def episode_external_links(episode)
    { 'YouTube' => episode.youtube_link, 'Mixcloud' => episode.mixcloud_link,
      'SoundCloud' => episode.soundcloud_link }.select do |_name, url|
      url.present? && url.match?(%r{\Ahttps?://[^/\s]+}i)
    end
  end

  def show_schedule(show)
    return if show.not_recurring?

    interval = case show.recurring_interval
    when 'month' then "#{show.recurring_cadence} #{show.recurring_weekday} of each month"
    when 'biweek' then "Every other #{show.recurring_weekday}"
    when 'week' then "Every #{show.recurring_weekday}"
    when 'day' then 'Daily'
    when 'year' then 'Yearly'
    end
    time = show.start_time&.in_time_zone(show.time_zone)&.strftime('%H:%M %Z')
    [interval, time].compact.join(' at ')
  end
end
