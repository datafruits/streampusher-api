class GuestShowBuilder
  def self.perform user, params, users_params, labels_params
    guest_series = ShowSeries.find_by(title: "GuestFruits")
    episode = guest_series.episodes.new params.except(:recurring_interval, :recurring_cadence, :recurring_weekday, :start_date, :end_date, :start_time, :end_time)
    start_time = DateTime.parse params[:start_time]
    end_time = DateTime.parse params[:end_time]
    start_date = DateTime.parse params[:start_date]
    time_zone = user.time_zone
    episode.start_at = DateTime.new start_date.year,
      start_date.month,
      start_date.day,
      start_time.hour,
      0,
      0,
      user.time_zone
    episode.end_at = episode.start_at + ((end_time - start_time) * 24).to_i.hours # wtf is this
    episode.playlist = guest_series.radio.default_playlist
    episode.dj_id = users_params[:user_ids].first
    episode.radio_id = guest_series.radio_id
    # TODO add hosts
    # if users_params.has_key? :user_ids
    #   users_params[:user_ids].each do |user_id|
    #     show_series.show_series_hosts.build user_id: user_id
    #   end
    # end
    if labels_params.has_key? :label_ids
      labels_params[:label_ids].each do |label_id|
        episode.scheduled_show_labels.build label_id: label_id
      end
    end
    episode.status = 'archive_unpublished'
    binding.pry
    episode
  end
end
