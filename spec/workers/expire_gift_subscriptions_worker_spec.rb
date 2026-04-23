require 'rails_helper'

RSpec.describe ExpireGiftSubscriptionsWorker, type: :worker do
  let(:radio) { FactoryBot.create :radio }
  let(:gifter) { FactoryBot.create :user, username: 'gifter', email: 'gifter@test.com' }
  let(:giftee) { FactoryBot.create :user, username: 'giftee', email: 'giftee@test.com' }

  describe '#perform' do
    it 'expires gift subscriptions that have passed expiration date' do
      # Create an active gift that expired yesterday
      expired_gift = FactoryBot.create :gift_subscription,
        gifter: gifter,
        giftee: giftee,
        status: :active,
        activated_at: 2.months.ago,
        expires_at: 1.day.ago

      worker = ExpireGiftSubscriptionsWorker.new
      worker.perform

      expired_gift.reload
      expect(expired_gift.status).to eq 'expired'
    end

    it 'removes supporter role if user has no other support' do
      giftee.add_role('supporter')
      
      expired_gift = FactoryBot.create :gift_subscription,
        gifter: gifter,
        giftee: giftee,
        status: :active,
        activated_at: 2.months.ago,
        expires_at: 1.day.ago

      worker = ExpireGiftSubscriptionsWorker.new
      worker.perform

      expect(giftee.reload.has_role?('supporter')).to eq false
    end

    it 'keeps supporter role if user has other active gifts' do
      giftee.add_role('supporter')
      
      # Expired gift
      expired_gift = FactoryBot.create :gift_subscription,
        gifter: gifter,
        giftee: giftee,
        status: :active,
        activated_at: 2.months.ago,
        expires_at: 1.day.ago

      # Active gift from another user
      another_gifter = FactoryBot.create :user, username: 'another', email: 'another@test.com'
      active_gift = FactoryBot.create :active_gift_subscription,
        gifter: another_gifter,
        giftee: giftee

      worker = ExpireGiftSubscriptionsWorker.new
      worker.perform

      expect(giftee.reload.has_role?('supporter')).to eq true
    end

    it 'keeps supporter role if user has emerald_supporter role' do
      giftee.add_role('supporter')
      giftee.add_role('emerald_supporter')
      
      expired_gift = FactoryBot.create :gift_subscription,
        gifter: gifter,
        giftee: giftee,
        status: :active,
        activated_at: 2.months.ago,
        expires_at: 1.day.ago

      worker = ExpireGiftSubscriptionsWorker.new
      worker.perform

      expect(giftee.reload.has_role?('supporter')).to eq true
    end

    it 'does not affect gifts that have not expired' do
      active_gift = FactoryBot.create :active_gift_subscription,
        gifter: gifter,
        giftee: giftee

      worker = ExpireGiftSubscriptionsWorker.new
      worker.perform

      active_gift.reload
      expect(active_gift.status).to eq 'active'
    end

    it 'does not process already expired gifts' do
      already_expired = FactoryBot.create :expired_gift_subscription,
        gifter: gifter,
        giftee: giftee

      # Should not try to expire it again
      expect(already_expired).not_to receive(:expire!)

      worker = ExpireGiftSubscriptionsWorker.new
      worker.perform
    end
  end
end
