class AccountMailer < ApplicationMailer
  def trial_will_end user
    @user = user
    mail subject: "Your free trial on Streampusher is ending soon", to: @user.email
  end

  def trial_ended user
    @user = user
    mail subject: "Your free trial on Streampusher has ended", to: @user.email
  end
end
