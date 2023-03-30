class DjAccountMailer < ApplicationMailer
  def welcome_email user, password, radio
    @user = user
    @password = password
    @radio = radio

    mail subject: "Your dj account on #{@radio.name} has been created", to: @user.email
  end

  def dj_manual user
    @user = user

    mail subject: "Datafruits DJ manual", to: @user.email
  end
end
