class Api::MicrotextsController < ApplicationController
  load_and_authorize_resource except: [:index]
  before_action :current_radio_required

  def index
    @microtexts = @current_radio.microtexts.order("RANDOM()").take(10)

    render json: @microtexts
  end

  def create
    @microtext = @current_radio.microtexts.new microtext_params
    @microtext.user = current_user
    if @microtext.save
      ActiveSupport::Notifications.instrument 'microtext.created', radio: @current_radio.name, username: @microtext.user.username, content: @microtext.content
      render json: @microtext
    else
      render json: { errors: @microtext.errors }, status: 422
    end
  end

  private
  def microtext_params
    params.require(:microtext).permit(:content)
  end
end
