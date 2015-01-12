class AdminController < ApplicationController
  def index
    authorize! :admin, :dashboard

    @subscriptions = Subscription.all
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
    redirect_to action: :radios, notice: 'radio rebooting...'
  end
end
