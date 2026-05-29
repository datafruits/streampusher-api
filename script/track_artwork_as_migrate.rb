def download_image url
  begin
    temp_file = Tempfile.new(['track_artwork', File.extname(url)])
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

tracks_to_migrate = Radio.first.tracks.where.not(artwork_file_name: nil)
                                .where.not(artwork_file_name: '')
                                .includes(as_image_attachment: :blob)

# Filter out shows that already have Active Storage images
tracks_needing_migration = tracks_to_migrate.reject do |track|
  track.as_image.attached?
end

total_tracks = tracks_needing_migration.count
puts "Found #{total_tracks} tracks series with Paperclip images that need migration to Active Storage"

if total_tracks == 0
  puts "No migration needed. All tracks either have Active Storage images or no images at all."
  return
end

tracks_needing_migration.each do |track|
  if track.artwork_file_name.blank?
    puts " SKIPPED: Track #{track.id}: #{track.slug} - no Paperclip image"
      skipped_count += 1
  end

  paperclip_url = track.artwork.url(:original)
  puts " Migrating Track #{track.id}: #{track.audio_file_name}"
  puts "  Source: #{paperclip_url}"

  temp_file = download_image(paperclip_url)
  if temp_file
    track.as_image.attach(
      io: temp_file,
      filename: track.artwork_file_name,
      content_type: track.artwork_content_type
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
  puts "  Total processed: #{migrated_count + error_count + skipped_count}/#{total_tracks}"
  puts "=" * 60

