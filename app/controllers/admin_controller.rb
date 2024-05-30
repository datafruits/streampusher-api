class AdminController < ApplicationController
  def index
    authorize! :admin, :dashboard

    @subscriptions = Subscription.all
  end

  def sign_in_as
    authorize! :admin, :sign_in_as
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url
  end

  def radios
    authorize! :admin, :radios

    @subscription = Subscription.find params[:id]
    @radios = @subscription.radios
  end

  def restart_radio
    authorize! :admin, :restart_radio
    @radio = Radio.find params[:id]
    @radio.boot_radio
    redirect_to action: :radios
  end

  def disable_radio
    authorize! :admin, :restart_radio
    @radio = Radio.find params[:id]
    @radio.disable_radio
    flash[:notice] = 'radio disabled...'
    redirect_to action: :radios
  end
end
