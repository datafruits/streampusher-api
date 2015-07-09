class AdminMailer < ApplicationMailer
  def user_signed_up user
    @user = user
    mail subject: "User signed up to Streampusher: #{@user.email}", to: ENV['ADMIN_EMAIL']
  end
end
