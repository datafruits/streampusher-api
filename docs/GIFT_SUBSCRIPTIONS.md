# Gift Subscription Feature

## Overview

The Gift Subscription feature allows users to purchase a 1-month premium membership for another user (or a random user) for $7. The recipient receives the "supporter" badge and all premium benefits for 30 days.

## Features

- **$7 one-time payment** via Stripe
- **Targeted or random gifting**: Gift to a specific user by username/ID OR let the system randomly select a recipient
- **Premium member badge**: Giftee automatically receives the "supporter" badge
- **30-day duration**: Gift subscriptions expire after 1 month
- **Expiration notifications**: Users are notified when their gift is about to expire
- **Automatic cleanup**: Background worker checks hourly for expired gifts
- **Smart role management**: Supporter badge is only removed if user has no other active support (gifts, Patreon, etc.)

## API Endpoints

### Create Gift Subscription

```
POST /api/gift_subscriptions
```

**Authentication Required**: Yes

**Parameters**:
```json
{
  "gift_subscription": {
    "giftee_id": 123,
    "message": "Enjoy your premium membership!"
  }
}
```

**Response**:
```json
{
  "gift_subscription": {
    "id": 1,
    "gifter_id": 456,
    "giftee_id": 123,
    "amount": "7.00",
    "status": "pending",
    "created_at": "2026-02-16T23:00:00.000Z"
  },
  "client_secret": "pi_xxx_secret_xxx"
}
```

## Configuration

### Environment Variables

```bash
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
STRIPE_GIFT_SUBSCRIPTION_WEBHOOK_SECRET=whsec_xxx
```

### Background Worker

The `ExpireGiftSubscriptionsWorker` runs every hour to expire gift subscriptions and manage supporter badges.

## Testing

```bash
bundle exec rspec spec/models/gift_subscription_spec.rb
bundle exec rspec spec/controllers/api/gift_subscriptions_controller_spec.rb
bundle exec rspec spec/workers/expire_gift_subscriptions_worker_spec.rb
```
