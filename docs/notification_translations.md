# Notification Translation Keys

This document describes the translation keys used for notifications in the streampusher-api.

## Overview

Notifications now use Ember Intl style translation keys instead of hardcoded English messages. The notification serializer includes:

- `message_key`: The translation key (e.g., "notifications.badge_award.strawberry")
- `message_params`: Parameters for interpolation (e.g., `{ "username": "mcfiredrill" }`)
- `message`: Legacy field (empty for new notifications)

## Translation Key Structure

### Badge Awards
- `notifications.badge_award.strawberry` - params: `{ username }`
- `notifications.badge_award.lemon` - params: `{ username }`
- `notifications.badge_award.orange` - params: `{ username }`
- `notifications.badge_award.banana` - params: `{ username }`
- `notifications.badge_award.cabbage` - params: `{ username }`
- `notifications.badge_award.watermelon` - params: `{ username }`
- `notifications.badge_award.pineapple` - params: `{ username }`
- `notifications.badge_award.limer` - params: `{ username }`
- `notifications.badge_award.dragionfruit` - params: `{ username }`
- `notifications.badge_award.blueberrinies` - params: `{ username }`
- `notifications.badge_award.beamsprout` - params: `{ username }`
- `notifications.badge_award.dj` - params: `{ username }`
- `notifications.badge_award.vj` - params: `{ username }`
- `notifications.badge_award.supporter` - params: `{ username }`
- `notifications.badge_award.gold_supporter` - params: `{ username }`
- `notifications.badge_award.emerald_supporter` - params: `{ username }`
- `notifications.badge_award.duckle` - params: `{ username }`

### User Progress
- `notifications.level_up` - params: `{ username, level }`
- `notifications.experience_point_award` - params: `{ amount, award_type }`
- `notifications.glorp_lottery_winner` - params: `{ username, amount, award_type, award_emoji }`

### Fruit Tickets
- `notifications.fruit_ticket_gift` - params: `{ from_username, amount }`
- `notifications.supporter_fruit_ticket_stipend` - params: `{ amount }`
- `notifications.track_playback_ticket_payment` - params: `{ amount }`
- `notifications.fruit_ticket_stimulus` - params: `{ amount }`
- `notifications.treasure_fruit_tix_reward` - params: `{ amount }`
- `notifications.shrimpo_deposit_return` - params: `{ amount }`

### Content & Social
- `notifications.show_comment` - params: `{ title }`
- `notifications.new_thread` - params: `{ title }`
- `notifications.new_thread_reply` - params: `{ title }`
- `notifications.new_wiki_page` - params: `{ title }`
- `notifications.wiki_page_update` - params: `{ title }`
- `notifications.new_datafruiter` - params: `{ username }`
- `notifications.profile_update` - params: `{ username }`
- `notifications.avatar_update` - params: `{ username, image_url }`
- `notifications.new_podcast` - params: `{ title }`

### Patreon
- `notifications.patreon_sub.with_gif` - params: `{ name, tier_name, patreon_checkout_link, gif_url }`
- `notifications.patreon_sub.without_gif` - params: `{ name, tier_name, patreon_checkout_link }`

### Shrimpo Events
- `notifications.shrimpo_started` - params: `{ title }`
- `notifications.shrimpo_entry` - params: `{ emoji, title, entry_count }`
- `notifications.shrimpo_voting_started` - params: `{ title }`
- `notifications.shrimpo_comment` - params: `{ title }`
- `notifications.shrimpo_entry_comment` - params: `{ title }`

## Example Usage in Frontend

```javascript
// Using Ember Intl service
const translatedMessage = this.intl.t(notification.message_key, notification.message_params);

// Example:
// message_key: "notifications.badge_award.strawberry"
// message_params: { "username": "mcfiredrill" }
// Result: "mcfiredrill got the strawbur badge!" (or localized equivalent)
```

## Migration Notes

- The `message` field is kept for backward compatibility but will be empty for new notifications
- Existing notifications will still have their original English messages in the `message` field
- Frontend should prioritize `message_key` + `message_params` when available, fallback to `message` for legacy notifications