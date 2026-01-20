# Script to consolidate duplicate labels
# If a track belongs to a duplicate label, it should be added to the label we will keep
# to preserve all track label data
#
# Usage: rails runner script/consolidate_duplicate_labels.rb [DRY_RUN=true]

dry_run = ENV['DRY_RUN'] == 'true'

if dry_run
  puts "=" * 50
  puts "DRY RUN MODE - No changes will be made"
  puts "=" * 50
end

puts "Starting label consolidation..."

# Find duplicate labels grouped by radio_id and name
duplicate_groups = Label.select(:radio_id, :name)
                        .group(:radio_id, :name)
                        .having("count(*) > 1")

total_groups = duplicate_groups.count
if total_groups == 0
  puts "No duplicate labels found. Database is clean!"
  exit 0
end

puts "Found #{total_groups} duplicate label groups to process..."

duplicate_count = 0
consolidated_count = 0
group_counter = 0

duplicate_groups.find_each do |duplicate_group|
  group_counter += 1
  
  # Get all labels with this radio_id and name
  labels_to_consolidate = Label.where(
    radio_id: duplicate_group.radio_id,
    name: duplicate_group.name
  ).order(:created_at)
  
  next if labels_to_consolidate.count <= 1
  
  # Keep the oldest label (first created)
  label_to_keep = labels_to_consolidate.first
  labels_to_remove = labels_to_consolidate[1..-1]
  
  puts "\n[#{group_counter}/#{total_groups}] Consolidating #{labels_to_consolidate.count} duplicate labels for radio #{duplicate_group.radio_id}, name: '#{duplicate_group.name}'"
  puts "  Keeping label ID #{label_to_keep.id} (created: #{label_to_keep.created_at})"
  puts "  Removing label IDs: #{labels_to_remove.map(&:id).join(', ')}"
  
  if dry_run
    puts "  [DRY RUN] Would consolidate these labels"
    next
  end
  
  Label.transaction do
    labels_to_remove.each do |label_to_remove|
      duplicate_count += 1
      
      begin
        # Move track_labels
        track_labels_moved = 0
        label_to_remove.track_labels.find_each do |track_label|
          # Check if the track is already associated with the label we're keeping
          unless TrackLabel.exists?(track_id: track_label.track_id, label_id: label_to_keep.id)
            track_label.update!(label_id: label_to_keep.id)
            track_labels_moved += 1
          else
            # Track is already associated with the label we're keeping, so we can delete this duplicate association
            track_label.destroy!
          end
        end
        
        # Move scheduled_show_labels
        show_labels_moved = 0
        label_to_remove.scheduled_show_labels.find_each do |show_label|
          # Check if the show is already associated with the label we're keeping
          unless ScheduledShowLabel.exists?(scheduled_show_id: show_label.scheduled_show_id, label_id: label_to_keep.id)
            show_label.update!(label_id: label_to_keep.id)
            show_labels_moved += 1
          else
            # Show is already associated with the label we're keeping, so we can delete this duplicate association
            show_label.destroy!
          end
        end
        
        # Move show_series_labels
        series_labels_moved = 0
        label_to_remove.show_series_labels.find_each do |series_label|
          # Check if the show series is already associated with the label we're keeping
          unless ShowSeriesLabel.exists?(show_series_id: series_label.show_series_id, label_id: label_to_keep.id)
            series_label.update!(label_id: label_to_keep.id)
            series_labels_moved += 1
          else
            # Show series is already associated with the label we're keeping, so we can delete this duplicate association
            series_label.destroy!
          end
        end
        
        puts "    Moved from label ID #{label_to_remove.id}: #{track_labels_moved} track associations, #{show_labels_moved} show associations, #{series_labels_moved} series associations"
        
        # Delete the duplicate label
        label_to_remove.destroy!
        consolidated_count += 1
        
      rescue => e
        puts "    ERROR processing label ID #{label_to_remove.id}: #{e.message}"
        raise e  # Re-raise to rollback the transaction
      end
    end
  end
  
  puts "  ✓ Consolidated successfully"
end

puts "\n" + "="*50
if dry_run
  puts "DRY RUN COMPLETE - No changes were made"
else
  puts "CONSOLIDATION COMPLETE"
end
puts "Found #{duplicate_count} duplicate labels"
unless dry_run
  puts "Consolidated #{consolidated_count} labels into their oldest counterparts"
  puts "All track, show, and series associations have been preserved"
end
puts "="*50