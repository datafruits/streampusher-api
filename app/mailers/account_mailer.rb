class AccountMailer < ApplicationMailer
  def welcome_new_account user
    @user = user
    mail subject: "Welcome to Streampusher", to: @user.email
  end

  def welcome_new_account_personalized user
    @user = user
    mail subject: "Anything I can help you with?", to: @user.email
  end

  def reset_password user
    @user = user
    mail subject: 'Reset your datafruits password', to: @user.email
  end
end
