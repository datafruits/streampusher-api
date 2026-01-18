def download_image url
  begin
    temp_file = Tempfile.new(['user_image', File.extname(url)])
    temp_file.binmode

    URI.open(url) do |image|
      temp_file.write(image.read)
    end

    temp_file.rewind
    temp_file
  rescue => e
    puts "      Download error: #{e.message}"
      temp_file&.close
    temp_file&.unlink
    nil
  end
end

migrated_count = 0
error_count = 0
skipped_count = 0

# scheduled shows
users_to_migrate = Radio.first.users.where.not(image_file_name: nil)
                                .where.not(image_file_name: '')
                                .includes(as_image_attachment: :blob)

# Filter out shows that already have Active Storage images
users_needing_migration = users_to_migrate.reject do |user|
  user.as_image.attached?
end

total_users = users_needing_migration.count
puts "Found #{total_users} scheduled users with Paperclip images that need migration to Active Storage"

if total_users == 0
  puts "No migration needed. All users either have Active Storage images or no images at all."
  return
end

users_needing_migration.each do |user|
  if user.image_file_name.blank?
    puts " SKIPPED: User #{user.id}: #{user.username} - no Paperclip image"
      skipped_count += 1
  end

  paperclip_url = user.image.url(:original)
  puts " Migrating ScheduledShow #{user.id}: #{user.username}"
  puts "  Source: #{paperclip_url}"

  temp_file = download_image(paperclip_url)
  if temp_file
    user.as_image.attach(
      io: temp_file,
      filename: user.image_file_name,
      content_type: user.image_content_type
    )
    temp_file.close
    temp_file.unlink

    puts " ✓ Successfully migrated to Active Storage"
    migrated_count += 1
  else
    puts " ✗ Failed to download image"
    error_count += 1
  end
end

puts "\n" + "=" * 60
puts "Migration Summary:"
puts "  Successfully migrated: #{migrated_count}"
  puts "  Errors encountered: #{error_count}"
  puts "  Skipped (already migrated): #{skipped_count}"
  puts "  Total processed: #{migrated_count + error_count + skipped_count}/#{total_users}"
  puts "=" * 60
