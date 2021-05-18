ScheduledShow.where.not(recurring_interval: 0).where(recurrant_original_id: nil).find_each do |original|

  puts "fixing recurrances for #{original.inspect}"
  #show_id = 403010
  #s = ScheduledShow.find(show_id)
  #original = s.recurrant_original
  #m50 = User.find_by(username: "m50")
  #shows = ScheduledShow.where(dj_id: 692)
  #puts shows.count

  original.recurrences.find_each do |show|
    #shows.find_each do |show|
    if show.performers.empty?
      if show.dj.present?
        puts "fixing show #{show.inspect}"
        show.performers << show.dj
        show.save!
      else
        puts "weird no dj for this show: #{show.inspect}"
      end
    end
  end
end

