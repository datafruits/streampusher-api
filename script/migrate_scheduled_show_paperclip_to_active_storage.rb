#!/usr/bin/env ruby
# 
# Script to migrate ScheduledShow Paperclip images to Active Storage
#
# This script copies Paperclip image attachments to Active Storage for ScheduledShow records
# that have Paperclip images but no Active Storage images attached yet.
#
# USAGE:
#   # Run in production (dry-run mode by default)
#   RAILS_ENV=production bundle exec ruby script/migrate_scheduled_show_paperclip_to_active_storage.rb
#
#   # Actually perform the migration (set DRY_RUN=false)  
#   RAILS_ENV=production DRY_RUN=false bundle exec ruby script/migrate_scheduled_show_paperclip_to_active_storage.rb
#
#   # Run with specific batch size
#   RAILS_ENV=production BATCH_SIZE=50 DRY_RUN=false bundle exec ruby script/migrate_scheduled_show_paperclip_to_active_storage.rb
#
# SAFETY:
#   - Runs in dry-run mode by default (no changes made)
#   - Only migrates shows that have Paperclip images but no Active Storage images
#   - Preserves all original Paperclip data and files
#   - Uses batching to avoid memory issues with large datasets
#   - Includes error handling and progress reporting
#

require_relative '../config/environment'
require 'open-uri'
require 'tempfile'

class ScheduledShowPaperclipMigrator
  def initialize(dry_run: true, batch_size: 100)
    @dry_run = dry_run
    @batch_size = batch_size
    @migrated_count = 0
    @error_count = 0
    @skipped_count = 0
  end

  def migrate!
    puts "Starting ScheduledShow Paperclip to Active Storage migration"
    puts "Mode: #{@dry_run ? 'DRY RUN (no changes will be made)' : 'LIVE MIGRATION'}"
    puts "Batch size: #{@batch_size}"
    puts "=" * 60

    # Find all ScheduledShows that have Paperclip images but no Active Storage images
    shows_to_migrate = ScheduledShow.where.not(image_file_name: nil)
                                   .where.not(image_file_name: '')
                                   .includes(active_storage_image_attachment: :blob)

    # Filter out shows that already have Active Storage images
    shows_needing_migration = shows_to_migrate.select do |show|
      !show.active_storage_image.attached?
    end

    total_shows = shows_needing_migration.count
    puts "Found #{total_shows} scheduled shows with Paperclip images that need migration to Active Storage"

    if total_shows == 0
      puts "No migration needed. All shows either have Active Storage images or no images at all."
      return
    end

    # Process in batches
    shows_needing_migration.each_slice(@batch_size).with_index do |batch, batch_index|
      puts "\nProcessing batch #{batch_index + 1} (#{batch.size} shows)..."
      
      batch.each do |show|
        migrate_show(show)
      end

      puts "Batch #{batch_index + 1} complete. Progress: #{@migrated_count + @error_count + @skipped_count}/#{total_shows}"
    end

    puts "\n" + "=" * 60
    puts "Migration Summary:"
    puts "  Successfully migrated: #{@migrated_count}"
    puts "  Errors encountered: #{@error_count}"
    puts "  Skipped (already migrated): #{@skipped_count}"
    puts "  Total processed: #{@migrated_count + @error_count + @skipped_count}/#{total_shows}"
    puts "=" * 60
  end

  private

  def migrate_show(show)
    begin
      # Double-check that this show needs migration
      if show.active_storage_image.attached?
        puts "  SKIPPED: Show #{show.id} (#{show.title}) - already has Active Storage image"
        @skipped_count += 1
        return
      end

      if show.image_file_name.blank?
        puts "  SKIPPED: Show #{show.id} (#{show.title}) - no Paperclip image"
        @skipped_count += 1
        return
      end

      paperclip_url = show.image.url(:original)
      puts "  Migrating Show #{show.id}: #{show.title}"
      puts "    Source: #{paperclip_url}"

      unless @dry_run
        # Download the original image
        temp_file = download_image(paperclip_url)
        
        if temp_file
          # Attach to Active Storage
          show.active_storage_image.attach(
            io: temp_file,
            filename: show.image_file_name,
            content_type: show.image_content_type
          )
          temp_file.close
          temp_file.unlink
          
          puts "    ✓ Successfully migrated to Active Storage"
        else
          puts "    ✗ Failed to download image"
          @error_count += 1
          return
        end
      else
        puts "    → Would migrate from: #{paperclip_url}"
      end

      @migrated_count += 1

    rescue => e
      puts "    ✗ ERROR migrating show #{show.id}: #{e.message}"
      puts "      #{e.backtrace.first}" if e.backtrace
      @error_count += 1
    end
  end

  def download_image(url)
    begin
      temp_file = Tempfile.new(['scheduled_show_image', File.extname(url)])
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
end

# Configuration from environment variables
dry_run = ENV.fetch('DRY_RUN', 'true').downcase != 'false'
batch_size = ENV.fetch('BATCH_SIZE', '100').to_i

# Run the migration
migrator = ScheduledShowPaperclipMigrator.new(dry_run: dry_run, batch_size: batch_size)
migrator.migrate!