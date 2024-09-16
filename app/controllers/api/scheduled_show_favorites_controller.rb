class Api::ScheduledShowFavoritesController < ApplicationController
  before_action :current_radio_required

  def create
    @scheduled_show_favorite = current_user.scheduled_show_favorites.new scheduled_show_favorite_params
    if @scheduled_show_favorite.save
      ActiveSupport::Notifications.instrument 'scheduled_show_favorite.created', current_user: current_user.email, radio: @current_radio.name, scheduled_show: @scheduled_show_favorite.scheduled_show.try(:title)
      render json: @scheduled_show_favorite, root: "scheduled_show_favorite"
    else
      render json: { errors: @scheduled_show_favorite.errors }, status: 422
    end
  end

  def destroy
    scheduled_show_favorite = current_user.scheduled_show_favorites.find params[:id]
    if scheduled_show_favorite.destroy
      ActiveSupport::Notifications.instrument 'scheduled_show_favorite.deleted', current_user: current_user.email, radio: @current_radio.name, scheduled_show: scheduled_show_favorite.scheduled_show.try(:title)
      head :ok
    else
      head :error
    end
  end

  private
  def scheduled_show_favorite_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :scheduled_show
    ])
  end
end
