module StatsHelper
  def average_sessions_per_hour listens, start_at, end_at

  end

  def average_listening_minutes_per_session listens, start_at, end_at
    listens.sum(&:length) / listens.count
  end
end
