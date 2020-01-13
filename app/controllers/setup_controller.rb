class SetupController < ApplicationController
  before_action :create_new_form, only: [:create]
  def create
    if User.count > 0 && Radio.count > 0
      render json: "not allowed", status: 401
    else
      @signup_form = SignupForm.new
      @signup_form.referer = session['referer']
      @signup_form.attributes = create_params
      if @signup_form.save
        render json: @signup_form.user, status: 201
      else
        render json: @signup_form.errors, status: 422
      end
    end
  end

  private

  def create_new_form
    user = User.new
    @signup_form = SignupForm.new(User.new)
  end

  def create_params
    params.require(:signup_form).permit(:email, :password, :time_zone, :radio_name)
  end
end
