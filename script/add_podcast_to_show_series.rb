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
  "city hunter" => "hojo",
  "mmainframe" => "hpc",
  "puro fantasia radio hrs" => "",
  "the curios show" => "skotvoid",
  "salinger" => "salinger",
  "solar system" => "",
  "mint jams" => "slugga",
  "flat402" => "hyuga daichi",
  "softserve" => "gearshfft",
}

datafruits = Radio.first

# if there's a slug, find the show series and add a new episode
# otherwise create the show series if there's a title under show_series col
# if neither exist, add to guest fruits
CSV.foreach(csv_path, headers: true) do |row|
  slug = row["show_series_slug"]
  # title = row[:show_series]
  filename = row["audio_file_name"]
  track = Track.find_by(audio_file_name: filename)
  show_series_name = row["show_series"]
  title = row["title"]
  created_at = row["created_at"]
  username = row["username"]
  if track.scheduled_show.blank?
    puts "#{filename} has no scheduled show"
    puts "slug: #{slug}"
    if slug
      puts "looking for show series with slug: #{slug}"
      show_series = ShowSeries.friendly.find slug
      if show_series
        # TODO strip date from show if it exists, somehow
        episode = show_series.episodes.new start_at: created_at, end_at: created_at, status: "archive_published", playlist: datafruits.default_playlist, dj: show_series.users.first, radio: datafruits
        if !title.blank?
          episode.title = title
        else
          episode.title = episode.formatted_episode_title
        end
        puts "saving episode w title: #{episode.title}"
        episode.save!
        track.update scheduled_show: episode
        episode.labels << track.labels
      else
        raise "couldn't find show series with slug: #{slug}"
      end
    elsif !title.blank?
      show_series = ShowSeries.find_by title: show_series_name
      if show_series
        episode = show_series.episodes.new title: title, start_at: created_at, end_at: created_at, status: "archive_published", playlist: datafruits.default_playlist, dj: show_series.users.first, radio: datafruits
        episode.save!
        track.update scheduled_show: episode
        episode.labels << track.labels
      else
        # create it
        # find user by show_series_user_mapping
        username = show_series_user_mapping[show_series_name]
        if username.blank?
          puts "couldn't find username for #{show_series_name}"
          next
        end
        user = User.find_by(username: username)
        if !user
          puts "couldn't find user with username: #{username}"
          next
        end
        show_series = ShowSeries.new title: show_series_name, status: "archived", radio: datafruits, time_zone: user.time_zone, description: show_series_name, start_time: Time.now, end_time: Time.now + 2.hours, status: "archived", start_date: Date.parse(created_at), end_date: Date.parse(created_at) + 2.hours, recurring_interval: :not_recurring
        show_series.show_series_hosts.build user: user
        show_series.save!
        # add episode
        episode = show_series.episodes.new title: title, start_at: created_at, end_at: created_at, status: "archive_published", playlist: datafruits.default_playlist, dj: show_series.users.first, radio: datafruits
        episode.save!
        track.update scheduled_show: episode
        episode.labels << track.labels
      end
    else
      puts "adding to guest fruits: #{filename}"
      guest_fruits = ShowSeries.find_by title: "GuestFruits"
      episode = guest_fruits.episodes.new start_at: created_at, end_at: created_at, status: "archive_published", radio: datafruits
      if !title.blank?
        episode.title = title
      else
        episode.title = episode.formatted_episode_title
      end
      if !username.blank?
        user = User.find_by username: username
        if !user
          puts "couldn't find user: #{username}, creating"
          user = User.create username: username
        end
        episode.dj = user
        episode.save!
        track.update scheduled_show: episode
        episode.labels << track.labels
      else
        puts "unknown user for track #{filename}"
      end
    end
  elsif track.scheduled_show.show_series.blank?
    puts "#{filename} has scheduled show, but no show series"
    show_series = ShowSeries.friendly.find slug
    if show_series
      show_series.episodes << track.scheduled_show
    end
  end
end
