# ScheduledShow Image Migration: Paperclip to Active Storage

This document outlines the migration of ScheduledShow image attachments from Paperclip to Active Storage while preserving all existing data and functionality.

## Overview

The migration adds Active Storage support alongside existing Paperclip functionality, enabling:
- New uploads to use Active Storage
- Existing Paperclip images to remain accessible
- Gradual migration of legacy data when needed
- Zero downtime deployment

## Implementation Details

### Model Changes (`app/models/scheduled_show.rb`)

```ruby
# New Active Storage attachment
has_one_attached :active_storage_image

# Existing Paperclip configuration (preserved)
has_attached_file :image, 
  styles: { :thumb => "x300", :medium => "x600" }, 
  path: ":attachment/:style/:basename.:extension",
  validate_media_type: false
```

### Fallback Strategy

The model includes intelligent fallback methods:

1. **`image_url`** - Returns Active Storage URL if available, otherwise Paperclip URL
2. **`thumb_image_url`** - Returns Active Storage variant URL if available, otherwise Paperclip thumb URL
3. **Serializers** - Updated to use model fallback methods transparently

### Controller Updates

Both `scheduled_shows_controller.rb` and `api/my_shows/episodes_controller.rb` support:
- Active Storage signed IDs for new uploads
- Legacy Paperclip data URI handling for backward compatibility

## Migration Script

The migration script at `script/migrate_scheduled_show_paperclip_to_active_storage.rb` provides:

### Safety Features
- **Dry-run mode by default** - No changes unless explicitly enabled
- **Batch processing** - Configurable batch sizes to prevent memory issues
- **Error handling** - Comprehensive error reporting and recovery
- **Progress tracking** - Detailed logging of migration progress

### Usage

```bash
# Dry run (default - no changes made)
RAILS_ENV=production bundle exec ruby script/migrate_scheduled_show_paperclip_to_active_storage.rb

# Live migration
RAILS_ENV=production DRY_RUN=false bundle exec ruby script/migrate_scheduled_show_paperclip_to_active_storage.rb

# Custom batch size
RAILS_ENV=production BATCH_SIZE=50 DRY_RUN=false bundle exec ruby script/migrate_scheduled_show_paperclip_to_active_storage.rb
```

### What the Script Does

1. Finds ScheduledShows with Paperclip images but no Active Storage images
2. Downloads original Paperclip images
3. Attaches them to Active Storage while preserving metadata
4. Provides detailed progress and error reporting
5. **Preserves all original Paperclip data** - nothing is deleted

## Deployment Strategy

### Phase 1: Deploy Code (Zero Downtime)
1. Deploy the updated code with both Active Storage and Paperclip support
2. All existing functionality continues to work
3. New uploads will use Active Storage
4. Old images continue to be served via Paperclip

### Phase 2: Migrate Data (Optional)
1. Run migration script in dry-run mode to assess scope
2. Run migration script during low-traffic period
3. Monitor for any issues
4. Verify migrated images are accessible

### Phase 3: Cleanup (Future)
Once all images are migrated and verified:
1. Remove Paperclip configuration (separate task)
2. Clean up database columns (separate migration)
3. Remove Paperclip gem dependency

## Verification

After deployment, verify functionality:

```ruby
# In Rails console
show = ScheduledShow.find(some_id)

# Check if Active Storage is working
show.active_storage_image.attached?

# Check if Paperclip fallback works
show.image.present?

# Test URL generation
show.image_url
show.thumb_image_url
```

## Rollback Plan

If issues occur:
1. The migration is backward compatible - simply revert the code
2. No data is lost as Paperclip configurations remain intact
3. All original functionality is preserved

## Benefits

- **Zero Downtime**: All existing functionality preserved during deployment
- **Gradual Migration**: Can migrate data at your own pace
- **Future Ready**: Modern Active Storage for new uploads
- **Safe**: Comprehensive error handling and dry-run capabilities
- **Transparent**: API responses remain identical to consumers

## Technical Notes

- Active Storage attachment named `active_storage_image` to avoid conflicts with Paperclip's `image`
- Image variants generated on-demand matching Paperclip's "x300" style (max height 300px)
- Controllers detect Active Storage signed IDs vs Paperclip data URIs automatically
- Serializers transparently use the fallback strategy

## Support

The implementation includes:
- Comprehensive error handling
- Detailed logging and progress reporting  
- Demo script to verify functionality
- Test suite covering all scenarios
- Documentation for troubleshooting