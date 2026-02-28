def download_image url
  begin
    temp_file = Tempfile.new(['show_series_image', File.extname(url)])
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

shows_to_migrate = Radio.first.show_series.where.not(image_file_name: nil)
                                .where.not(image_file_name: '')
                                .includes(as_image_attachment: :blob)

# Filter out shows that already have Active Storage images
shows_needing_migration = shows_to_migrate.reject do |show|
  show.as_image.attached?
end

total_shows = shows_needing_migration.count
puts "Found #{total_shows} shows series with Paperclip images that need migration to Active Storage"

if total_shows == 0
  puts "No migration needed. All shows either have Active Storage images or no images at all."
  return
end

shows_needing_migration.each do |show|
  if show.image_file_name.blank?
    puts " SKIPPED: ShowSeries #{show.id}: #{show.slug} - no Paperclip image"
      skipped_count += 1
  end

  paperclip_url = show.image.url(:original)
  puts " Migrating ScheduledShow #{show.id}: #{show.slug}"
  puts "  Source: #{paperclip_url}"

  temp_file = download_image(paperclip_url)
  if temp_file
    show.as_image.attach(
      io: temp_file,
      filename: show.image_file_name,
      content_type: show.image_content_type
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
  puts "  Total processed: #{migrated_count + error_count + skipped_count}/#{total_shows}"
  puts "=" * 60
