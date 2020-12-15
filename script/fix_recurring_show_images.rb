# https://stackoverflow.com/questions/1489183/colorized-ruby-output-to-the-terminal
class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

def missing_image?(url)
  response = HTTParty.get(url)
  return response.code != 200
end

Radio.first.scheduled_shows.where.not(recurring_interval: 0).where(recurrant_original_id: nil).find_each do |original|

  puts "fixing recurrances for #{original.inspect}"
  #show_id = 403010
  #s = ScheduledShow.find(show_id)
  #original = s.recurrant_original
  #m50 = User.find_by(username: "m50")
  #shows = ScheduledShow.where(dj_id: 692)
  #puts shows.count

  original.recurrences.find_each do |show|
    puts "testing image for show: #{show.inspect}".pink
    url = show.image.url
    uri = URI.parse url
    if !uri.host.nil?
      puts "testing url... #{url}".light_blue
      if missing_image?(show.image.url)
        if show.tracks.any?
          if show.tracks.first.artwork.present?
            puts "image missing! copying from track artwork...".red
            show.image = show.tracks.first.artwork
          else
            puts "image missing! copying from original...".green
            show.image = original.image
          end
        end
        if show.save
          puts "saved!".green
        else
          puts "couldn't save show...".red
          puts show.errors
        end
      else
        puts "image OK!".green
      end
    else
      puts "couldn't parse url: #{url}".red
    end
  end
end
