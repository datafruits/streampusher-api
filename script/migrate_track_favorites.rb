TrackFavorite.find_each do |tf|
  scheduled_show = tf.track.scheduled_show
  if scheduled_show
    unless ScheduledShowFavorite.where(scheduled_show: scheduled_show, user: tf.user).any?
      ScheduledShowFavorite.create! scheduled_show: scheduled_show, user: tf.user
    end
  end
end
