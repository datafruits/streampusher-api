require "stripe"
class SignupForm
  include ActiveModel::Model
  attr_reader :user, :radio
  attr_accessor :referer
  delegate :email, :email=, :password, :password=, to: :user
  delegate :name, to: :radio

  def initialize user=User.new, radio=Radio.new
    @user = user
    @user.role = "admin"
    @radio = radio
  end

  def radio_name= name
    @radio.name = name
  end

  def radios= radios
    @radio.name = radios[:name]
  end

  def any_errors?
    self.user.errors.any? || self.radio.errors.any?
  end

  def attributes= attrs
    attrs.each do |k,v|
      self.send("#{k}=", v)
    end
    puts radio.name.present?
    @user.username = radio.name.gsub(/\s/,"")
    @user.referer = referer
  end

  def save
    begin
      ActiveRecord::Base.transaction do
        if @user.save!
          if @radio.save!
            @user.radios << @radio
            ActiveSupport::Notifications.instrument 'user.signup', email: @user.email, radio: @radio.name
            UserSignedUpNotifier.notify @user
            @radio.boot_radio
          end
        end
      end
    rescue ActiveRecord::RecordInvalid,Stripe::InvalidRequestError 
      return false
    end
  end
end
