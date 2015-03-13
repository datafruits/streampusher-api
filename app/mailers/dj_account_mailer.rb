class DjAccountMailer < ActionMailer::Base
  default from: "from@example.com"

  def dj_account_welcome user, password, radio
    @user = user
    @password = password
    @radio = radio

    mail subject: "Your dj account on #{radio.name} has been created", to: user.email
  end
end
