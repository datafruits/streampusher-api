show_id = ARGV[1]
s = ScheduledShow.find(show_id)
original = s.recurrant_original

original.recurrences.find_each do |show|
  if show.performers.empty?
    show.performers << show.dj
  end
  show.save!
end
