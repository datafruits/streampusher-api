class ExpireGiftSubscriptionsWorker
  include Sidekiq::Worker

  def perform
    # Find all active gift subscriptions that have expired
    expired_gifts = GiftSubscription.expired

    expired_gifts.each do |gift|
      Rails.logger.info "Expiring gift subscription #{gift.id} for user #{gift.giftee.username}"
      
      # Mark gift as expired and send notification
      gift.expire!
      
      # Remove supporter role if user has no other active gifts or patreon
      unless gift.should_keep_supporter_role?
        if gift.giftee.has_role?('supporter')
          gift.giftee.remove_role('supporter')
          Rails.logger.info "Removed supporter role from #{gift.giftee.username}"
        end
      end
    end
  end
end
