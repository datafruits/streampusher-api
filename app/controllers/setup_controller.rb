class SetupController < ApplicationController
  before_action :create_new_form, only: [:create]
  def create
    @signup_form = SignupForm.new
    @signup_form.referer = session['referer']
    @signup_form.attributes = create_params
    #@plan = Plan.find_or_create_by name: "Free Trial"
    if @signup_form.save
      render json: @signup_form.user, status: 201
    else
      render json: @signup_form.errors, status: 422
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
