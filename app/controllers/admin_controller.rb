class AdminController < ApplicationController
  def index
    authorize! :admin, :dashboard

    @subscriptions = Subscription.all
  end
end
