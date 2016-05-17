class ExistingUserRadio < StandardError; end

class DjSignup
  def self.perform user_params, radio
    user = User.find_by_email(user_params[:email])
    if user.present?
      user_radio = user.user_radios.build(radio: radio)
      unless user_radio.save
        raise ExistingUserRadio
      end
      user.save
      DjAccountMailer.added_to_radio(user, radio).deliver_later
      ActiveSupport::Notifications.instrument 'dj.added_to_radio', current_user: user.email, radio: radio.name, dj: user.email
    else
      user = User.new user_params
      user.role = "dj"
      user.user_radios.build(radio: radio)
      password = Devise.friendly_token.first(8)
      user.password = password
      if user.valid?
        user.save
        DjAccountMailer.welcome_email(user, password, radio).deliver_later
        ActiveSupport::Notifications.instrument 'dj.created', current_user: user.email,
          radio: radio.name, dj: user.email
      end
    end
    user
  end
end
