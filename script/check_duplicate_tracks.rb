#!/usr/bin/env ruby

# Test script to identify duplicate tracks without removing them
# Run with: rails runner script/check_duplicate_tracks.rb

puts "Checking for duplicate tracks based on scheduled_show_id and audio_file_name..."

# Find tracks that have duplicates based on scheduled_show_id and audio_file_name
duplicate_groups = Track.where.not(scheduled_show_id: nil)
                       .where.not(audio_file_name: [nil, ''])
                       .group(:scheduled_show_id, :audio_file_name)
                       .having('count(*) > 1')
                       .count

puts "Found #{duplicate_groups.count} groups with duplicate tracks"

if duplicate_groups.count > 0
  puts "\nDuplicate groups:"
  duplicate_groups.each do |(scheduled_show_id, audio_file_name), count|
    puts "\nGroup: scheduled_show_id=#{scheduled_show_id}, audio_file_name='#{audio_file_name}' (#{count} duplicates)"
    
    # Get all tracks in this duplicate group
    duplicate_tracks = Track.where(scheduled_show_id: scheduled_show_id, audio_file_name: audio_file_name)
                            .order(:created_at)
    
    duplicate_tracks.each_with_index do |track, index|
      status = index == 0 ? " (WOULD KEEP)" : " (WOULD REMOVE)"
      puts "  Track ID #{track.id}, created: #{track.created_at}#{status}"
    end
  end
else
  puts "No duplicates found! The unique index should be safe to apply."
end