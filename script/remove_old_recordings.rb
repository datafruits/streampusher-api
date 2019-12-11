old_recordings = Recording.where("created_at < ?", 7.days.ago)
puts "Removing #{old_recordings.count} old recordings..."

old_recordings.find_each do |recording|
  File.delete recording.path
  recording.destroy
end
