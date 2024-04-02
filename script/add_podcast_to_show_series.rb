# TODO
require 'csv'

csv_path = "/tmp/missing_podcasts.csv"

# should datafruits5, dxdf etc be under guest fruits?
# or its own show series?
show_series_user_mapping = {
  "club trash" => "alptrack",
  "case of the mondays" => "frail",
  "chex mix" => "jallen250",
  "dj supermarket" => "",
  "dxdf" => "",
  "essential fruits" => "mcfiredrill",
  "good morning datafruits" => "oven",
  "happy hybrids" => "tim",
  "city hunter" => "",
  "mmainframe" => "hpc",
  "puro fantasia radio hrs" => "",
  "the curios show" => "skotvoid",
  "salinger" => "salinger",
  "solar system" => "",
  "mint jams" => "slugga",
  "flat402" => "hyuga daichi",
  "softserve" => "gearshfft",
}

# if there's a slug, find the show series and add a new episode
# otherwise create the show series if there's a title under show_series col
# if neither exist, add to guest fruits
CSV.foreach(csv_path, headers: true) do |row|
  slug = row[:show_series_slug]
  title = row[:show_series]
  track = Track.find_by(title: row[:audio_file_name])
  title = row[:title]
  if slug
    show_series = ShowSeries.friendly.find slug
    if show_series
      # strip date from show if it exists, somehow
      episode = show_series.scheduled_shows.new title: title, start_at: row[:created_at], end_at: row[:created_at], status: "archive_published"
      episode.save!
      track.update scheduled_show: episode
      episode.labels << track.labels
    else
      puts "couldn't find show series with slug: #{slug}"
    end
  elsif title
    show_series = ShowSeries.find_by title: title
    if show_series
      episode = show_series.episodes.new
    else
      # create it
      # find user by show_series_user_mapping
      username = show_series_user_mapping[title]
      if username.blank?
        puts "couldn't find username for #{title}"
        next
      end
      user = User.find_by(username: username)
      if !user
        puts "couldn't find user with username: #{username}"
        next
      end
      #
      show_series = ShowSeries.new user: user, title: title, status: "archived"
      show_series.save!
      # add episode
      episode = show_series.episodes.new
    end
  else
    # add to guest fruits
    guest_fruits = ShowSeries.find_by title: "Guest Fruits"
    # TODO user??
    episode = guest_fruits.episodes.new title: title, start_at: row[:created_at], end_at: row[:created_at], status: "archive_published"
    episode.save!
    track.update scheduled_show: episode
    episode.labels << track.labels
  end
end
