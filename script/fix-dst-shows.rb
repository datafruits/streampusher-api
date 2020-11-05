show_ids = [
  395173, # tchan
  416887, # alptrack
  417419, # frail
  441902, # lucky me
  437781, # snailzone
  414464, # getdizzy
  421944, # severed FM
  403004, # ufo online
  433248, # guerilla rave
  433712, # martinradio
  426829, # etc
  14695, # fengir's key
  438729, # identity.null
  423571, # anysong sundays
  425914, # free potatoes
  421018, # thanks1
  435897, # earth surface open
  434821, # jules dj speed limit
  439648, # lazy anarchist show
]

show_ids.each do |show_id|
  show = ScheduledShow.find!(show_id)
  puts "updating #{show.title}"
  show.fall_forward_recurrances_for_dst!
end
