class GiftSubscription < ActiveRecord::Base
  belongs_to :gifter, class_name: 'User', foreign_key: 'gifter_id'
  belongs_to :giftee, class_name: 'User', foreign_key: 'giftee_id', optional: true

  enum status: [:pending, :active, :expired, :canceled]

  validates :gifter_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :stripe_payment_intent_id, uniqueness: true, allow_nil: true

  scope :active, -> { where(status: :active) }
  scope :expiring_soon, -> { active.where('expires_at <= ?', 7.days.from_now) }
  scope :expired, -> { where('expires_at < ? AND status = ?', Time.current, statuses[:active]) }

  # Activate the gift subscription
  def activate!
    return false if active? || expired?
    
    transaction do
      if giftee.blank?
        # Assign to random user who doesn't already have supporter role
        eligible_users = User.where.not(id: gifter_id).to_a.reject do |u|
          u.has_role?('supporter') || u.has_role?('emerald_supporter') || u.has_role?('gold_supporter')
        end
        
        if eligible_users.any?
          self.giftee = eligible_users.sample
        else
          # If no eligible users, assign to random user anyway
          self.giftee = User.where.not(id: gifter_id).order('RANDOM()').first
        end
      end

      self.status = :active
      self.activated_at = Time.current
      self.expires_at = 1.month.from_now
      save!

      # Award supporter badge to giftee
      giftee.add_role('supporter') unless giftee.has_role?('supporter')
      
      # Create notification
      Notification.create!(
        notification_type: 'gift_subscription_received',
        user: giftee,
        source: self,
        send_to_chat: true,
        send_to_user: true
      )
      
      # Notify gifter as well
      Notification.create!(
        notification_type: 'gift_subscription_sent',
        user: gifter,
        source: self,
        send_to_chat: false,
        send_to_user: true
      )
    end
    true
  rescue => e
    Rails.logger.error "Failed to activate gift subscription #{id}: #{e.message}"
    false
  end

  # Mark as expired and optionally remove supporter role
  def expire!
    return false unless active?
    
    transaction do
      self.status = :expired
      save!
      
      # Send expiration notification to giftee
      Notification.create!(
        notification_type: 'gift_subscription_expired',
        user: giftee,
        source: self,
        send_to_chat: false,
        send_to_user: true
      )
    end
    true
  rescue => e
    Rails.logger.error "Failed to expire gift subscription #{id}: #{e.message}"
    false
  end

  # Check if user should keep supporter role after gift expires
  # (e.g., if they have other active gifts or patreon subscription)
  def should_keep_supporter_role?
    # Check if user has other active gift subscriptions
    other_active_gifts = GiftSubscription.active.where(giftee_id: giftee_id).where.not(id: id).exists?
    return true if other_active_gifts
    
    # Check if user has patreon pledge
    patreon_supporter = giftee.has_role?('emerald_supporter') || giftee.has_role?('gold_supporter')
    return true if patreon_supporter
    
    false
  end

  def days_until_expiration
    return 0 unless active? && expires_at
    ((expires_at - Time.current) / 1.day).ceil
  end
end
