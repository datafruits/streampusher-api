# When running db:migrate db:seed in the same process, column info cached during
# migration may be stale (e.g. show_series_id added mid-migrate). Force a reload.
[Radio, User, UserRadio, Label, Playlist, ShowSeries, ShowSeriesHost, ScheduledShow, ScheduledShowLabel, ScheduledShowPerformer].each(&:reset_column_information)

ActiveRecord::Base.transaction do

  # ============================================================
  # 1. Radio
  # ============================================================
  radio = Radio.find_or_create_by!(name: "datafruits") do |r|
    r.enabled = true
  end
  puts "Radio: #{radio.name} (id=#{radio.id})"

  # ============================================================
  # 2. Users
  # ============================================================
  admin = User.find_or_create_by!(email: "admin@datafruits.fm") do |u|
    u.username  = "admin"
    u.password  = "password"
    u.role      = "admin"
    u.time_zone = "UTC"
    u.enabled   = true
  end
  puts "User: #{admin.username} (#{admin.role})"

  dj = User.find_or_create_by!(email: "dj@datafruits.fm") do |u|
    u.username  = "dj_testuser"
    u.password  = "password"
    u.role      = "dj"
    u.time_zone = "UTC"
    u.enabled   = true
  end
  puts "User: #{dj.username} (#{dj.role})"

  listener = User.find_or_create_by!(email: "listener@datafruits.fm") do |u|
    u.username  = "listener"
    u.password  = "password"
    u.role      = "listener"
    u.time_zone = "UTC"
    u.enabled   = true
  end
  puts "User: #{listener.username} (#{listener.role})"

  # ============================================================
  # 3. UserRadio — link DJs to the radio
  # ============================================================
  [admin, dj].each do |user|
    UserRadio.find_or_create_by!(user: user, radio: radio)
  end
  puts "UserRadios linked"

  # ============================================================
  # 4. Labels
  # ============================================================
  label_names = %w[electronic experimental ambient jazz beats]
  labels = label_names.map do |name|
    label = Label.find_or_create_by!(name: name, radio: radio)
    puts "Label: #{label.name}"
    label
  end

  # ============================================================
  # 5. Extra Playlist (default already created by Radio.after_create)
  # ============================================================
  chill_playlist = Playlist.find_or_create_by!(name: "chill mix", radio: radio)
  puts "Playlist: #{chill_playlist.name}"
  default_playlist = radio.default_playlist
  puts "Default playlist: #{default_playlist.name} (id=#{default_playlist.id})"

  # ============================================================
  # 6. ShowSeries
  # ============================================================
  show_series = ShowSeries.find_or_initialize_by(title: "Test Transmissions", radio: radio)
  if show_series.new_record?
    show_series.description        = "A weekly showcase of electronic and experimental music from the datafruits crew."
    show_series.status             = :active
    show_series.recurring_interval = :not_recurring
    show_series.time_zone          = "UTC"
    # start_time / end_time store the clock time for recurrence generation;
    # they're datetime columns — use an arbitrary date, only the time component matters.
    show_series.start_time         = Time.utc(2000, 1, 1, 20, 0, 0)  # 8:00 PM UTC
    show_series.end_time           = Time.utc(2000, 1, 1, 22, 0, 0)  # 10:00 PM UTC
    show_series.start_date         = Time.utc(2000, 1, 1)
    show_series.default_playlist   = default_playlist
    show_series.save!
  end
  puts "ShowSeries: #{show_series.title} (id=#{show_series.id})"

  # Link dj as a host of the show series
  ShowSeriesHost.find_or_create_by!(user: dj, show_series: show_series)
  puts "ShowSeriesHost linked: #{dj.username}"

  # ============================================================
  # 7. ScheduledShows (episodes)
  # Validation `start_at_cannot_be_in_the_past` runs on :create only.
  # For the past show we create it in the future then update the times afterward.
  # ============================================================

  # Past show — create with future times, then update to past to bypass create validation
  past_show = ScheduledShow.find_or_initialize_by(title: "Test Transmissions - Past Episode", radio: radio)
  if past_show.new_record?
    past_show.dj          = dj
    past_show.show_series = show_series
    past_show.playlist    = default_playlist
    past_show.description = "An archived episode from the past."
    past_show.start_at    = 1.week.from_now
    past_show.end_at      = 1.week.from_now + 2.hours
    past_show.save!
    # Now push times into the past — skips create validations, fires update callbacks only
    past_show.update_columns(
      start_at: 2.weeks.ago,
      end_at:   2.weeks.ago + 2.hours
    )
    past_show.reload
  end
  puts "ScheduledShow (past): #{past_show.title}"

  # Future show 1
  future_show_1 = ScheduledShow.find_or_initialize_by(title: "Test Transmissions - Episode 1", radio: radio)
  if future_show_1.new_record?
    future_show_1.dj          = dj
    future_show_1.show_series = show_series
    future_show_1.playlist    = default_playlist
    future_show_1.description = "Coming up next week — tune in for some electronic explorations."
    future_show_1.start_at    = 1.week.from_now.beginning_of_hour
    future_show_1.end_at      = 1.week.from_now.beginning_of_hour + 2.hours
    future_show_1.save!
  end
  puts "ScheduledShow (future 1): #{future_show_1.title}"

  # Future show 2
  future_show_2 = ScheduledShow.find_or_initialize_by(title: "Test Transmissions - Episode 2", radio: radio)
  if future_show_2.new_record?
    future_show_2.dj          = dj
    future_show_2.show_series = show_series
    future_show_2.playlist    = default_playlist
    future_show_2.description = "Two weeks out — deep in the ambient zone."
    future_show_2.start_at    = 2.weeks.from_now.beginning_of_hour
    future_show_2.end_at      = 2.weeks.from_now.beginning_of_hour + 2.hours
    future_show_2.save!
  end
  puts "ScheduledShow (future 2): #{future_show_2.title}"

  # ============================================================
  # 8. ScheduledShowLabel — tag the future shows
  # ============================================================
  electronic_label = labels.find { |l| l.name == "electronic" }
  experimental_label = labels.find { |l| l.name == "experimental" }

  [future_show_1, future_show_2].each do |show|
    [electronic_label, experimental_label].each do |label|
      ScheduledShowLabel.find_or_create_by!(scheduled_show: show, label: label)
    end
  end
  puts "ScheduledShowLabels linked"

  # ============================================================
  # 9. WikiPage — index returns 404 when empty, so seed at least one
  # ============================================================
  unless WikiPage.exists?
    WikiPage.create!(
      title: "Welcome to datafruits",
      body:  "This is the datafruits wiki. Add pages to document the community, shows, and more."
    )
    puts "WikiPage created"
  end

  # ============================================================
  # Done
  # ============================================================
  puts ""
  puts "Seed complete:"
  puts "  Radios:          #{Radio.count}"
  puts "  Users:           #{User.count}"
  puts "  Labels:          #{Label.count}"
  puts "  Playlists:       #{Playlist.count}"
  puts "  ShowSeries:      #{ShowSeries.count}"
  puts "  ScheduledShows:  #{ScheduledShow.count}"
  puts "  WikiPages:       #{WikiPage.count}"
end
