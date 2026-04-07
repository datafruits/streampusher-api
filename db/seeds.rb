# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ---------------------------------------------------------------------------
# Radio
# ---------------------------------------------------------------------------
radio = Radio.find_or_create_by!(name: "datafruits")
puts "Radio: #{radio.name} (id=#{radio.id})"

# ---------------------------------------------------------------------------
# Users
# ---------------------------------------------------------------------------
admin = User.find_or_initialize_by(email: "admin@datafruits.fm")
if admin.new_record?
  admin.username             = "admin"
  admin.password             = "password"
  admin.password_confirmation = "password"
  admin.time_zone            = "UTC"
  admin.role                 = "owner dj"
  admin.display_name         = "Admin"
  admin.save!
end
puts "Admin user: #{admin.email} / password"

dj1 = User.find_or_initialize_by(email: "tonyde@datafruits.fm")
if dj1.new_record?
  dj1.username             = "tonyde"
  dj1.password             = "password"
  dj1.password_confirmation = "password"
  dj1.time_zone            = "America/New_York"
  dj1.role                 = "dj"
  dj1.display_name         = "Tony de"
  dj1.save!
end
puts "DJ user: #{dj1.username}"

dj2 = User.find_or_initialize_by(email: "yoshibo@datafruits.fm")
if dj2.new_record?
  dj2.username             = "yoshibo"
  dj2.password             = "password"
  dj2.password_confirmation = "password"
  dj2.time_zone            = "Asia/Tokyo"
  dj2.role                 = "dj"
  dj2.display_name         = "Yoshibo"
  dj2.save!
end
puts "DJ user: #{dj2.username}"

# Associate users with the radio
UserRadio.find_or_create_by!(user: admin, radio: radio)
UserRadio.find_or_create_by!(user: dj1,   radio: radio)
UserRadio.find_or_create_by!(user: dj2,   radio: radio)

# ---------------------------------------------------------------------------
# Labels
# ---------------------------------------------------------------------------
label_electronic = Label.find_or_create_by!(name: "electronic", radio: radio)
label_ambient    = Label.find_or_create_by!(name: "ambient",    radio: radio)
label_jazz       = Label.find_or_create_by!(name: "jazz",       radio: radio)
puts "Labels: #{[label_electronic, label_ambient, label_jazz].map(&:name).join(', ')}"

# ---------------------------------------------------------------------------
# Default playlist (created automatically by Radio after_create callback)
# ---------------------------------------------------------------------------
default_playlist = radio.default_playlist

# ---------------------------------------------------------------------------
# Show Series
# ---------------------------------------------------------------------------
series1 = ShowSeries.find_or_initialize_by(title: "Fruit Salad", radio: radio)
if series1.new_record?
  series1.description         = "A weekly show featuring eclectic electronic music from around the world."
  series1.time_zone           = "America/New_York"
  series1.start_time          = Time.parse("2025-01-01 20:00:00 UTC")
  series1.end_time            = Time.parse("2025-01-01 22:00:00 UTC")
  series1.start_date          = 1.year.ago
  series1.end_date            = 1.year.from_now
  series1.status              = :active
  series1.recurring_interval  = :not_recurring
  series1.default_playlist    = default_playlist
  series1.save!
end
ShowSeriesHost.find_or_create_by!(show_series: series1, user: dj1)
ShowSeriesLabel.find_or_create_by!(show_series: series1, label: label_electronic)
puts "Show series: #{series1.title}"

series2 = ShowSeries.find_or_initialize_by(title: "Tokyo Nights", radio: radio)
if series2.new_record?
  series2.description         = "Late-night ambient and electronic music from Tokyo."
  series2.time_zone           = "Asia/Tokyo"
  series2.start_time          = Time.parse("2025-01-01 23:00:00 UTC")
  series2.end_time            = Time.parse("2025-01-02 01:00:00 UTC")
  series2.start_date          = 1.year.ago
  series2.end_date            = 1.year.from_now
  series2.status              = :active
  series2.recurring_interval  = :not_recurring
  series2.default_playlist    = default_playlist
  series2.save!
end
ShowSeriesHost.find_or_create_by!(show_series: series2, user: dj2)
ShowSeriesLabel.find_or_create_by!(show_series: series2, label: label_ambient)
puts "Show series: #{series2.title}"

# ---------------------------------------------------------------------------
# Tracks (metadata only – no real audio file required in development)
# ---------------------------------------------------------------------------
track1 = Track.find_or_initialize_by(audio_file_name: "datafruits/tracks/fruit_salad_ep1.mp3", radio: radio)
if track1.new_record?
  track1.title  = "Fruit Salad - Episode 1"
  track1.artist = "tonyde"
  track1.length = 7200
  track1.save!
end

track2 = Track.find_or_initialize_by(audio_file_name: "datafruits/tracks/tokyo_nights_ep1.mp3", radio: radio)
if track2.new_record?
  track2.title  = "Tokyo Nights - Episode 1"
  track2.artist = "yoshibo"
  track2.length = 7200
  track2.save!
end

track3 = Track.find_or_initialize_by(audio_file_name: "datafruits/tracks/fruit_salad_ep2.mp3", radio: radio)
if track3.new_record?
  track3.title  = "Fruit Salad - Episode 2"
  track3.artist = "tonyde"
  track3.length = 7020
  track3.save!
end
puts "Tracks: #{[track1, track2, track3].map(&:title).join(', ')}"

# ---------------------------------------------------------------------------
# Scheduled Shows / Archives
# The future-date validation is only on: :create, so we use save(validate: false)
# to seed past (archived) episodes.
# ---------------------------------------------------------------------------

# Archive – Fruit Salad Episode 1
unless ScheduledShow.exists?(title: "Fruit Salad - Episode 1", radio: radio)
  show1             = ScheduledShow.new
  show1.radio       = radio
  show1.dj          = dj1
  show1.title       = "Fruit Salad - Episode 1"
  show1.description = "First episode of Fruit Salad featuring deep house and ambient techno."
  show1.start_at    = 1.month.ago.beginning_of_hour
  show1.end_at      = 1.month.ago.beginning_of_hour + 2.hours
  show1.playlist    = default_playlist
  show1.show_series = series1
  show1.status      = :archive_published
  show1.save(validate: false)
  show1.tracks << track1
  puts "Archived show: #{show1.title}"
end

# Archive – Tokyo Nights Episode 1
unless ScheduledShow.exists?(title: "Tokyo Nights - Episode 1", radio: radio)
  show2             = ScheduledShow.new
  show2.radio       = radio
  show2.dj          = dj2
  show2.title       = "Tokyo Nights - Episode 1"
  show2.description = "First episode of Tokyo Nights – a journey through late-night ambient sounds."
  show2.start_at    = 3.weeks.ago.beginning_of_hour
  show2.end_at      = 3.weeks.ago.beginning_of_hour + 2.hours
  show2.playlist    = default_playlist
  show2.show_series = series2
  show2.status      = :archive_published
  show2.save(validate: false)
  show2.tracks << track2
  puts "Archived show: #{show2.title}"
end

# Archive – Fruit Salad Episode 2
unless ScheduledShow.exists?(title: "Fruit Salad - Episode 2", radio: radio)
  show3             = ScheduledShow.new
  show3.radio       = radio
  show3.dj          = dj1
  show3.title       = "Fruit Salad - Episode 2"
  show3.description = "Second episode of Fruit Salad featuring jazz-infused electronic beats."
  show3.start_at    = 1.week.ago.beginning_of_hour
  show3.end_at      = 1.week.ago.beginning_of_hour + 2.hours
  show3.playlist    = default_playlist
  show3.show_series = series1
  show3.status      = :archive_published
  show3.save(validate: false)
  show3.tracks << track3
  puts "Archived show: #{show3.title}"
end

# Future – Fruit Salad Episode 3 (upcoming, no archive yet)
unless ScheduledShow.exists?(title: "Fruit Salad - Episode 3", radio: radio)
  show4             = ScheduledShow.new
  show4.radio       = radio
  show4.dj          = dj1
  show4.title       = "Fruit Salad - Episode 3"
  show4.description = "Third episode of Fruit Salad – live set with special guests."
  show4.start_at    = 1.week.from_now.beginning_of_hour
  show4.end_at      = 1.week.from_now.beginning_of_hour + 2.hours
  show4.playlist    = default_playlist
  show4.show_series = series1
  show4.save!
  puts "Upcoming show: #{show4.title}"
end

puts "\nSeed complete!"
puts "  Radio    : #{radio.name}"
puts "  Admin    : #{admin.email} / password"
puts "  DJs      : #{dj1.username}, #{dj2.username}"
puts "  Series   : #{series1.title}, #{series2.title}"
puts "  Archives : Fruit Salad ep1 & ep2, Tokyo Nights ep1"
puts "  Upcoming : Fruit Salad ep3"
