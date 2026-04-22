class ListArchivesWorker < ActiveJob::Base
  queue_as :default

  def perform
    puts "Writing archive list to cache..."
    for radio in Radio.all
      archives = radio.scheduled_shows.
        where(status: :archive_published).
        order("start_at DESC")
      Rails.cache.write("chronological_archives/#{radio.id}", archives)
      puts "Archive list cached for #{radio.name}"
    end
  end
end
