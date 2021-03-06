class AccountMailer < ApplicationMailer
  def welcome_new_account user
    @user = user
    mail subject: "Welcome to Streampusher", to: @user.email
  end

  def welcome_new_account_personalized user
    @user = user
    mail subject: "Anything I can help you with?", to: @user.email
  end

  def trial_will_end user
    @user = user
    mail subject: "Your free trial on Streampusher is ending soon", to: @user.email
  end

  def trial_ended user
    @user = user
    mail subject: "Your free trial on Streampusher has ended", to: @user.email
  end

  def day_after_trial_ended user
    @user = user
    mail subject: "Can I offer you a discount?", to: @user.email
  end

  def subscription_updated user, old_plan, new_plan
    @user = user
    @old_plan = old_plan
    @new_plan = new_plan
    mail subject: "You have upgraded your plan on Streampusher", to: @user.email
  end

  def invoice user, invoice
    @user = user
    @invoice = invoice
    mail subject: "Your monthly subscription invoice", to: @user.email
  end

  def payment_failed user, invoice
    @user = user
    @invoice = invoice
    mail subject: "Your payment method has failed", to: @user.email
  end
end
