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
end
