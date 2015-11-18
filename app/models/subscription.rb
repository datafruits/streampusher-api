class Subscription < ActiveRecord::Base
  belongs_to :plan
  validates_presence_of :plan_id
  belongs_to :user
  has_many :radios
  attr_accessor :stripe_card_token

  def trial_days_left
    (Date.parse(Time.at(self.trial_ends_at).to_s) - Date.today).to_i
  end

  def card_present?
    last_4_digits.present? && exp_month.present? && exp_year.present?
  end

  def save_without_payment
    save! if valid?
  end

  def save_with_free_trial(*)
    if valid?
      customer = Stripe::Customer.create(description: self.user.email, plan: self.plan.name)
      self.on_trial = true
      self.trial_ends_at = Time.at(customer.subscriptions.data.first.trial_end)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    return false
  end

  def save_with_card(*)
    if valid?
      customer = Stripe::Customer.create(description: self.user.email, plan: plan_id, card: stripe_card_token)
      self.on_trial = false
      self.stripe_customer_token = customer.id
      self.last_4_digits = customer.cards.first.last4
      self.exp_month = customer.cards.first.exp_month
      self.exp_year = customer.cards.first.exp_year
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    return false
  end

  def update_with_new_card attributes
    with_transaction_returning_status do
      assign_attributes(attributes)
      if valid?
        customer = Stripe::Customer.retrieve self.stripe_customer_token
        card = customer.sources.create source: stripe_card_token
        card.save
        customer.default_card = card.id
        subscription = customer.subscriptions.first
        subscription.plan = self.plan.name
        customer.save
        self.on_trial = false
        self.stripe_customer_token = customer.id
        self.last_4_digits = customer.cards.first.last4
        self.exp_month = customer.cards.first.exp_month
        self.exp_year = customer.cards.first.exp_year
        save!
      end
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    return false
  end
end
