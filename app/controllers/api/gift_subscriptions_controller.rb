class Api::GiftSubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:webhook]
  before_action :current_radio_required, except: [:webhook]
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def create
    gift_subscription = GiftSubscription.new(gift_subscription_params)
    gift_subscription.gifter = current_user
    gift_subscription.status = :pending
    
    begin
      # Create Stripe PaymentIntent for $7
      payment_intent = Stripe::PaymentIntent.create(
        amount: 700, # $7.00 in cents
        currency: 'usd',
        metadata: {
          gifter_id: current_user.id,
          giftee_id: gift_subscription.giftee_id,
          type: 'gift_subscription'
        }
      )
      
      gift_subscription.stripe_payment_intent_id = payment_intent.id
      
      if gift_subscription.save
        # If payment is already successful (shouldn't happen normally)
        if payment_intent.status == 'succeeded'
          gift_subscription.activate!
        end
        
        render json: {
          gift_subscription: gift_subscription,
          client_secret: payment_intent.client_secret
        }, status: :created
      else
        render json: { errors: gift_subscription.errors.full_messages }, status: :unprocessable_entity
      end
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error creating gift subscription: #{e.message}"
      render json: { error: "Payment processing error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def index
    # Show gift subscriptions sent by current user
    sent_gifts = current_user.sent_gift_subscriptions.order(created_at: :desc)
    # Show gift subscriptions received by current user
    received_gifts = current_user.received_gift_subscriptions.order(created_at: :desc)
    
    render json: {
      sent: sent_gifts,
      received: received_gifts
    }
  end

  def show
    gift_subscription = GiftSubscription.find(params[:id])
    
    # Only allow gifter or giftee to view
    unless gift_subscription.gifter_id == current_user.id || gift_subscription.giftee_id == current_user.id
      render json: { error: 'Unauthorized' }, status: :forbidden
      return
    end
    
    render json: gift_subscription
  end

  # Webhook endpoint to handle Stripe payment confirmations
  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_GIFT_SUBSCRIPTION_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: :bad_request
      return
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      gift_subscription = GiftSubscription.find_by(stripe_payment_intent_id: payment_intent.id)
      
      if gift_subscription && gift_subscription.pending?
        gift_subscription.activate!
      end
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object
      gift_subscription = GiftSubscription.find_by(stripe_payment_intent_id: payment_intent.id)
      
      if gift_subscription
        gift_subscription.update(status: :canceled)
        Rails.logger.error "Payment failed for gift subscription #{gift_subscription.id}"
      end
    end

    render json: { received: true }
  end

  private

  def gift_subscription_params
    params.require(:gift_subscription).permit(:giftee_id, :message)
  end
end
