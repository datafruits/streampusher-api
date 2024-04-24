shows_to_create = [
  {title: "boy para", dj: "djdogtreat", description: "core, bass, swag"},
  {title: "THE PLANET FUN SHOW", dj: "djfingerblast", description: "A PIPING HOT BRAND NEW SHOW, BROADCAST DIRECTLY FROM \r\nFUNDERLAND'S LUXURY STUDIOS STRAIGHT TO YOUR BEDROOM! DJ FINGERBLAST WILL TAKE YOU ON A JOURNEY OF SELF DISCOVERY WITH THE HELP FROM HIS TRUSTY FRIENDS! FULL OF CONTENT & THE HIGHEST QUALITY OF MP3S YOU'VE EVER HEARD! GUEST MIXES FROM GFOTY, DJ CUM, SPACE CANDY + MAXIMUM BELLEND. LOCK IN! BUCKLE UP! GET READY! LETS GO!"},
  {title: "Et Ctch", dj: "joragon", description: "Et Ctch Radio"},
  {title: "gutterfruits", dj: "klugarsh", description: "gutterfruits"},
  {title: "city hunter", dj: "hojo", description: "the city is calling me"},
  {title: "good morning datafruits", dj: "oven", description: "wake up to the sounds only a morning on datafruits can provide: Good Morning @datafruits"},
  {title: "Puro Fantasía Radio Hrs", dj: "purofantasia", description: "with J Dende"},
  {title: "Happy Hyrbids", dj: "tim", description: "A journey through some happily hybrid dance music"},
  {title: "vibesmeme's Fuck Real Life!", dj: "vibesmeme", description: "vibesmeme's Fuck Real Life"},
  {title: "dj supermarket", dj: "mcfiredrill", description: "international DJ supermarket a URL/VR and sometimes it was IRL extravaganza"},
]

shows_to_create.each do |show|
  user = User.find_by(username: show.dj)
  time = Time.now
  show_series = ShowSeries.new title: show.title, status: "archived", radio: datafruits, time_zone: user.time_zone, description: show.description, start_time: time, end_time: time + 2.hours, status: "archived", start_date: Date.parse(time), end_date: Date.parse(time) + 2.hours, recurring_interval: :not_recurring
  show_series.show_series_hosts.build user: user
  show_series.save!
end
