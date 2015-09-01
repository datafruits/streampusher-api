class AdminMailer < ApplicationMailer
  def user_signed_up user
    @user = user
    mail subject: "User signed up to Streampusher: #{@user.email}", to: ENV['ADMIN_EMAIL']
  end

  def radio_not_reachable radio
    @radio = radio
    mail subject: "Radio #{radio.name} is not reachable", to: ENV['ADMIN_EMAIL']
  end
end
