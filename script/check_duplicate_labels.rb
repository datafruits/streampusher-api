# Script to check for duplicate labels
# This is a read-only script to identify potential duplicates

puts "Checking for duplicate labels..."

# Find duplicate labels grouped by radio_id and name
duplicate_groups = Label.select(:radio_id, :name)
                        .group(:radio_id, :name)
                        .having("count(*) > 1")

total_duplicates = 0

if duplicate_groups.any?
  puts "\nFound duplicate label groups:"
  
  duplicate_groups.find_each do |duplicate_group|
    # Get all labels with this radio_id and name
    labels = Label.where(
      radio_id: duplicate_group.radio_id,
      name: duplicate_group.name
    ).order(:created_at)
    
    puts "\nRadio #{duplicate_group.radio_id}, name: '#{duplicate_group.name}'"
    puts "  #{labels.count} duplicate labels:"
    
    labels.each do |label|
      track_count = label.track_labels.count
      show_count = label.scheduled_show_labels.count
      series_count = label.show_series_labels.count
      
      puts "    ID #{label.id} (created: #{label.created_at}) - #{track_count} tracks, #{show_count} shows, #{series_count} series"
      total_duplicates += 1
    end
  end
  
  puts "\n" + "="*50
  puts "SUMMARY"
  puts "Found #{duplicate_groups.count} duplicate label groups"
  puts "Total duplicate labels: #{total_duplicates}"
  puts "Run consolidate_duplicate_labels.rb to fix these duplicates"
  puts "="*50
else
  puts "No duplicate labels found. Database is clean!"
end