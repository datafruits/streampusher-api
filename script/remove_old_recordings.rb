puts "RUNNING REMOVE OLD RECORDINGS SCRIPT"
old_recordings = Recording.where("created_at < ?", 7.days.ago)
puts "Removing #{old_recordings.count} old recordings..."

old_recordings.find_each do |recording|
  if File.exist? recording.path
    File.delete recording.path
  end
  recording.destroy
end
