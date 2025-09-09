#!/usr/bin/env ruby

# Script to remove duplicate tracks based on scheduled_show_id and audio_file_name
# This allows the unique index migration to succeed
# Run with: rails runner script/remove_duplicate_tracks.rb

puts "Starting duplicate track removal process..."

# Find tracks that have duplicates based on scheduled_show_id and audio_file_name
duplicate_groups = Track.where.not(scheduled_show_id: nil)
                       .where.not(audio_file_name: [nil, ''])
                       .group(:scheduled_show_id, :audio_file_name)
                       .having('count(*) > 1')
                       .count

puts "Found #{duplicate_groups.count} groups with duplicate tracks"

if duplicate_groups.count == 0
  puts "No duplicates found! The unique index should be safe to apply."
  exit
end

total_removed = 0

# Process duplicates in a transaction for safety
ActiveRecord::Base.transaction do
  duplicate_groups.each do |(scheduled_show_id, audio_file_name), count|
    puts "\nProcessing group: scheduled_show_id=#{scheduled_show_id}, audio_file_name='#{audio_file_name}' (#{count} duplicates)"
    
    # Get all tracks in this duplicate group, ordered by created_at (keep the oldest)
    duplicate_tracks = Track.where(scheduled_show_id: scheduled_show_id, audio_file_name: audio_file_name)
                            .order(:created_at)
    
    # Keep the first (oldest) track, remove the rest
    tracks_to_remove = duplicate_tracks.offset(1)
    
    tracks_to_remove.each do |track|
      puts "  Removing duplicate track ID #{track.id} (created: #{track.created_at})"
      track.destroy!
      total_removed += 1
    end
    
    # Show which track we kept
    kept_track = duplicate_tracks.first
    puts "  Kept track ID #{kept_track.id} (created: #{kept_track.created_at})"
  end
end

puts "\nDuplicate removal complete!"
puts "Total tracks removed: #{total_removed}"
puts "You can now run the migration to add the unique index."