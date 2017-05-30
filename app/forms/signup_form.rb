class SignupForm
  include ActiveModel::Model
  attr_reader :user, :subscription, :radio
  attr_accessor :referer
  delegate :email, :email=, :password, :password=, to: :user
  delegate :name, to: :radio
  delegate :plan_id, :coupon, to: :subscription

  def initialize user=User.new, subscription=Subscription.new, radio=Radio.new
    @user = user
    @user.role = "owner"
    @subscription = subscription
    @radio = radio
  end

  def any_errors?
    self.user.errors.any? || self.subscription.errors.any? || self.radio.errors.any?
  end

  def attributes= attrs
    attrs.each do |k,v|
      self.send("#{k}=", v)
    end
    @user.username = radio.name.gsub(/\s/,"")
    @user.referer = referer
  end

  def subscription= attrs
    @subscription.plan_id = attrs[:plan_id]
    @subscription.stripe_card_token = attrs[:stripe_card_token]
    @subscription.coupon = attrs[:coupon]
    @radio.name = attrs[:radios][:name]
  end

  def save
    begin
      ActiveRecord::Base.transaction do
        if @user.save!
          @subscription.user_id = @user.id
          @subscription.radios << @radio
          if @radio.save!
            @user.subscription = subscription
            @user.subscription.save_with_free_trial!
            @user.radios << @user.subscription.radios.first
            ActiveSupport::Notifications.instrument 'user.signup', email: @user.email, radio: @radio.name
            UserSignedUpNotifier.notify @user
            @radio.boot_radio
          end
        end
      end
    rescue ActiveRecord::RecordInvalid, Stripe::InvalidRequestError
      return false
    end
  end
end
