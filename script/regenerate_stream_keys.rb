User.find_each do |user|
  user.stream_key = nil
  user.save!
  puts "Regenerated stream key for user #{user.id} (#{user.username})"
end
