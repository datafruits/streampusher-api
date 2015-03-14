# Preview all emails at http://localhost:3000/rails/mailers/dj_account_mailer
class DjAccountMailerPreview < ActionMailer::Preview
  def welcome_email
    password = Devise.friendly_token.first(8)
    DjAccountMailer.welcome_email(User.first, password, Radio.first)
  end
end
