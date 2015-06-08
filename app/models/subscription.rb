class Subscription < ActiveRecord::Base
  belongs_to :plan
  validates_presence_of :plan_id
  belongs_to :user
  has_many :radios
  attr_accessor :stripe_card_token

  def save_without_payment
    save! if valid?
  end

  def save(*)
    if valid?
      customer = Stripe::Customer.create(description: self.user.email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      self.last_4_digits = customer.cards.first.last4
      self.exp_month = customer.cards.first.exp_month
      self.exp_year = customer.cards.first.exp_year
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
  end
end
