class DjAccountMailer < ApplicationMailer
  def welcome_email user, password, radio
    @user = user
    @password = password
    @radio = radio

    mail subject: "Your dj account on #{@radio.name} has been created", to: @user.email
  end
end
