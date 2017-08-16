module StatsHelper
  def average_sessions_per_hour listens
    if listens.length > 0
      total_hours = listens.length
      total_listens = listens.values.sum
      total_listens / total_hours
    else
      0
    end
  end

  def average_listening_minutes_per_session listens
    if listens.length > 0
      listens.map{|m| m.length / 60.0 }.sum / listens.length
    else
      0
    end
  end

  def average_listening_minutes_per_hour listens
    lengths = {}
    listens.order("date_trunc('hour', start_at) ASC")
           .pluck("date_trunc('hour', start_at)", :start_at, :end_at).each do |listen|
      lengths[listen[0]] = [] unless lengths.has_key?(listen[0])
      lengths[listen[0]] << ((listen[2] - listen[1]) / 60.0)
    end
    lengths.each do |k,v|
      average = (v.sum / v.length).round
      lengths[k] = average
    end
    lengths
  end
end
