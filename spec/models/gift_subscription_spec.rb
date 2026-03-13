require 'rails_helper'

RSpec.describe GiftSubscription, type: :model do
  let(:radio) { FactoryBot.create :radio }
  let(:gifter) { FactoryBot.create :user, username: 'gifter', email: 'gifter@test.com' }
  let(:giftee) { FactoryBot.create :user, username: 'giftee', email: 'giftee@test.com' }

  describe 'validations' do
    it 'requires a gifter' do
      gift = GiftSubscription.new(giftee: giftee, amount: 7.00)
      expect(gift.valid?).to eq false
      expect(gift.errors[:gifter_id]).to be_present
    end

    it 'requires a positive amount' do
      gift = GiftSubscription.new(gifter: gifter, giftee: giftee, amount: -5.00)
      expect(gift.valid?).to eq false
      expect(gift.errors[:amount]).to be_present
    end

    it 'ensures stripe payment intent ID is unique' do
      FactoryBot.create :gift_subscription, stripe_payment_intent_id: 'pi_123'
      gift = GiftSubscription.new(gifter: gifter, giftee: giftee, amount: 7.00, stripe_payment_intent_id: 'pi_123')
      expect(gift.valid?).to eq false
      expect(gift.errors[:stripe_payment_intent_id]).to be_present
    end
  end

  describe 'associations' do
    it 'belongs to gifter' do
      gift = FactoryBot.create :gift_subscription, gifter: gifter
      expect(gift.gifter).to eq gifter
    end

    it 'belongs to giftee' do
      gift = FactoryBot.create :gift_subscription, giftee: giftee
      expect(gift.giftee).to eq giftee
    end

    it 'allows giftee to be nil for random gifting' do
      gift = FactoryBot.build :gift_subscription, gifter: gifter, giftee: nil
      expect(gift.valid?).to eq true
    end
  end

  describe '#activate!' do
    context 'with a specific giftee' do
      it 'activates the gift subscription and awards supporter badge' do
        gift = FactoryBot.create :gift_subscription, gifter: gifter, giftee: giftee, status: :pending
        
        expect(gift.activate!).to eq true
        gift.reload
        
        expect(gift.status).to eq 'active'
        expect(gift.activated_at).to be_present
        expect(gift.expires_at).to be_present
        expect(giftee.reload.has_role?('supporter')).to eq true
      end

      it 'creates notifications for gifter and giftee' do
        gift = FactoryBot.create :gift_subscription, gifter: gifter, giftee: giftee, status: :pending
        
        expect {
          gift.activate!
        }.to change(Notification, :count).by(2)
        
        giftee_notification = Notification.find_by(user: giftee, notification_type: 'gift_subscription_received')
        expect(giftee_notification).to be_present
        
        gifter_notification = Notification.find_by(user: gifter, notification_type: 'gift_subscription_sent')
        expect(gifter_notification).to be_present
      end
    end

    context 'with random giftee selection' do
      it 'assigns a random eligible user' do
        # Create some users
        eligible_user1 = FactoryBot.create :user, username: 'eligible1', email: 'eligible1@test.com'
        eligible_user2 = FactoryBot.create :user, username: 'eligible2', email: 'eligible2@test.com'
        
        gift = FactoryBot.create :gift_subscription, gifter: gifter, giftee: nil, status: :pending
        
        expect(gift.activate!).to eq true
        gift.reload
        
        expect(gift.giftee).to be_present
        expect(gift.giftee).not_to eq gifter
        expect(gift.status).to eq 'active'
      end

      it 'prefers users without supporter badges' do
        # Create user without supporter badge
        non_supporter = FactoryBot.create :user, username: 'nonsupporter', email: 'nonsupporter@test.com'
        
        # Create user with supporter badge
        supporter = FactoryBot.create :user, username: 'supporter', email: 'supporter@test.com'
        supporter.add_role('supporter')
        
        # Run activation multiple times to increase probability of selecting non-supporter
        selected_users = []
        5.times do
          gift = FactoryBot.create :gift_subscription, gifter: gifter, giftee: nil, status: :pending
          gift.activate!
          selected_users << gift.reload.giftee
        end
        
        # At least one should be the non-supporter (statistically very likely)
        expect(selected_users).to include(non_supporter)
      end
    end

    it 'does not activate if already active' do
      gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      original_activated_at = gift.activated_at
      
      expect(gift.activate!).to eq false
      expect(gift.reload.activated_at).to eq original_activated_at
    end

    it 'does not activate if expired' do
      gift = FactoryBot.create :expired_gift_subscription, gifter: gifter, giftee: giftee
      
      expect(gift.activate!).to eq false
    end
  end

  describe '#expire!' do
    it 'marks active gift as expired' do
      gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      
      expect(gift.expire!).to eq true
      gift.reload
      
      expect(gift.status).to eq 'expired'
    end

    it 'creates expiration notification' do
      gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      
      expect {
        gift.expire!
      }.to change(Notification, :count).by(1)
      
      notification = Notification.find_by(user: giftee, notification_type: 'gift_subscription_expired')
      expect(notification).to be_present
    end

    it 'does not expire if not active' do
      gift = FactoryBot.create :gift_subscription, gifter: gifter, giftee: giftee, status: :pending
      
      expect(gift.expire!).to eq false
    end
  end

  describe '#should_keep_supporter_role?' do
    it 'returns true if user has other active gift subscriptions' do
      gift1 = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      gift2 = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      
      expect(gift1.should_keep_supporter_role?).to eq true
    end

    it 'returns true if user has emerald_supporter role' do
      gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      giftee.add_role('emerald_supporter')
      
      expect(gift.should_keep_supporter_role?).to eq true
    end

    it 'returns true if user has gold_supporter role' do
      gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      giftee.add_role('gold_supporter')
      
      expect(gift.should_keep_supporter_role?).to eq true
    end

    it 'returns false if user has no other support' do
      gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      
      expect(gift.should_keep_supporter_role?).to eq false
    end
  end

  describe '#days_until_expiration' do
    it 'returns days until expiration for active gift' do
      gift = FactoryBot.create :gift_subscription, 
        gifter: gifter, 
        giftee: giftee, 
        status: :active,
        expires_at: 10.days.from_now
      
      expect(gift.days_until_expiration).to be_between(9, 10)
    end

    it 'returns 0 for expired gift' do
      gift = FactoryBot.create :expired_gift_subscription, gifter: gifter, giftee: giftee
      
      expect(gift.days_until_expiration).to eq 0
    end
  end

  describe 'scopes' do
    before do
      @active_gift = FactoryBot.create :active_gift_subscription, gifter: gifter, giftee: giftee
      @pending_gift = FactoryBot.create :gift_subscription, gifter: gifter, giftee: giftee, status: :pending
      @expired_gift = FactoryBot.create :expired_gift_subscription, gifter: gifter, giftee: giftee
    end

    it 'finds active gifts' do
      expect(GiftSubscription.active).to include(@active_gift)
      expect(GiftSubscription.active).not_to include(@pending_gift)
      expect(GiftSubscription.active).not_to include(@expired_gift)
    end

    it 'finds gifts expiring soon' do
      expiring_soon = FactoryBot.create :active_gift_subscription,
        gifter: gifter,
        giftee: giftee,
        expires_at: 3.days.from_now
      
      expect(GiftSubscription.expiring_soon).to include(expiring_soon)
      expect(GiftSubscription.expiring_soon).not_to include(@active_gift) # expires in 1 month
    end

    it 'finds expired gifts that need processing' do
      needs_expiration = FactoryBot.create :gift_subscription,
        gifter: gifter,
        giftee: giftee,
        status: :active,
        expires_at: 1.day.ago
      
      expect(GiftSubscription.expired).to include(needs_expiration)
      expect(GiftSubscription.expired).not_to include(@active_gift)
      expect(GiftSubscription.expired).not_to include(@expired_gift) # already marked expired
    end
  end
end
