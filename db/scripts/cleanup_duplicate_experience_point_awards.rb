# Script to clean up duplicate ExperiencePointAward rows before adding unique index
# Run with: bin/rails runner db/scripts/cleanup_duplicate_experience_point_awards.rb
# This script:
# - finds groups (award_type, source_id) with more than one row
# - deletes the duplicate rows, keeping the row with the smallest id for each group
# WARNING: This uses `delete_all` for the duplicate rows to avoid triggering model callbacks
# which may have side-effects (e.g. re-calculating user xp).

puts "Starting cleanup of duplicate ExperiencePointAward rows"

# Load model (script run via rails runner, so models are available)

# Find duplicate groups
duplicates = ExperiencePointAward.group(:award_type, :source_id).having('COUNT(*) > 1').count
if duplicates.empty?
  puts "No duplicate groups found. Nothing to do."
  exit 0
end

puts "Found #{duplicates.size} duplicate group(s)"

total_deleted = 0

duplicates.each do |(award_type, source_id), count|
  puts "Processing group award_type=#{award_type.inspect}, source_id=#{source_id.inspect} (#{count} rows)"

  # Get ids ordered deterministically (smallest id kept)
  ids = ExperiencePointAward.where(award_type: award_type, source_id: source_id).order(:id).pluck(:id)
  keep_id = ids.shift

  if ids.empty?
    puts "  No duplicates to delete for this group (unexpected)."
    next
  end

  # Delete duplicates (bypass callbacks) - avoids side-effects (e.g. re-calculating user xp)
  deleted = ExperiencePointAward.where(id: ids).delete_all
  total_deleted += deleted

  puts "  Kept id=#{keep_id}, deleted #{deleted} duplicate row(s)"
end

puts "Done. Total duplicate rows deleted: #{total_deleted}"
