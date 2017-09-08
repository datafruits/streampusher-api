class SubscriptionsController < ApplicationController
  load_and_authorize_resource
  def edit
    @plans = Plan.where.not(name: "Free Trial")
    if @subscription.on_trial?
      @selected_plan = Plan.find_by(name: "Hobbyist")
    else
      @selected_plan = @subscription.plan
    end
  end

  def update
    if @subscription.update_with_new_card create_params
      flash[:notice] = "Updated your subscription successfully."
      ActiveSupport::Notifications.instrument 'subscription.updated', user: current_user.email, radio: @current_radio.name, subscription: @subscription.inspect
      redirect_to edit_subscription_path @subscription
    else
      flash[:error] = "Error updating your subscription."
      render 'edit'
    end
  end

  private
  def create_params
    params.require(:subscription).permit(:plan_id, :stripe_card_token, :coupon)
  end
end
