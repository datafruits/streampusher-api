# Label Consolidation Scripts

This directory contains scripts to identify and consolidate duplicate labels in the system.

## Scripts

### `check_duplicate_labels.rb`

A read-only script that identifies duplicate labels without making any changes.

**Usage:**
```bash
# Using rails runner
rails runner script/check_duplicate_labels.rb

# Using Docker (if using the docker setup)
docker-compose -p streampusher -f docker-compose-dev.yml run --rm rails ./docker_wrapper.sh bundle exec rails runner script/check_duplicate_labels.rb
```

### `consolidate_duplicate_labels.rb`

Consolidates duplicate labels by:
1. Finding labels with the same name within the same radio
2. Keeping the oldest label (by created_at timestamp)
3. Moving all track, show, and series associations to the kept label
4. Deleting the duplicate labels

**Usage:**
```bash
# Run in dry-run mode first to see what would be changed
DRY_RUN=true rails runner script/consolidate_duplicate_labels.rb

# Actually perform the consolidation
rails runner script/consolidate_duplicate_labels.rb

# Using Docker (if using the docker setup)
docker-compose -p streampusher -f docker-compose-dev.yml run --rm rails ./docker_wrapper.sh bundle exec rails runner script/consolidate_duplicate_labels.rb
```

## What Gets Consolidated

The script handles these associations:
- **Track Labels** (`track_labels` table) - Links between tracks and labels
- **Scheduled Show Labels** (`scheduled_show_labels` table) - Links between scheduled shows and labels  
- **Show Series Labels** (`show_series_labels` table) - Links between show series and labels

## Safety Features

- **Transaction Safety**: All operations are wrapped in database transactions
- **Duplicate Prevention**: Checks for existing associations before creating new ones
- **Error Handling**: Rolls back changes if any error occurs
- **Dry Run Mode**: Test the script with `DRY_RUN=true` before making changes
- **Detailed Logging**: Shows exactly what labels are being consolidated and how many associations are moved

## Example Output

```
Starting label consolidation...

Consolidating 2 duplicate labels for radio 1, name: 'electronic'
  Keeping label ID 123 (created: 2024-01-15 10:30:00 UTC)
  Removing label IDs: 456
    Moved from label ID 456: 5 track associations, 2 show associations, 1 series associations
  ✓ Consolidated successfully

==================================================
CONSOLIDATION COMPLETE
Found 1 duplicate labels
Consolidated 1 labels into their oldest counterparts
All track, show, and series associations have been preserved
==================================================
```