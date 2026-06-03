User.find_each do |user|
  user.stream_key = nil
  user.save!
  puts "Regenerated stream key for user #{user.id} (#{user.username})"
rescue => e
  puts "ERROR regenerating stream key for user #{user.id} (#{user.username}): #{e.message}"
end
