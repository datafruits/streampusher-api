class Api::TrackFavoritesController < ApplicationController
  before_action :current_radio_required

  def create
    @track_favorite = current_user.track_favorites.new track_favorite_params
    if @track_favorite.save
      ActiveSupport::Notifications.instrument 'track_favorite.created', current_user: current_user.email, radio: @current_radio.name, track: @track_favorite.track.title
      render json: @track_favorite, root: "track_favorite"
    else
      render json: { errors: @track_favorite.errors }, status: 422
    end
  end

  def destroy
    track_favorite = current_user.track_favorites.find params[:id]
    if track_favorite.destroy
      ActiveSupport::Notifications.instrument 'track_favorite.deleted', current_user: current_user.email, radio: @current_radio.name, track: track_favorite.track.title
      head :ok
    else
      head :error
    end
  end

  private
  def track_favorite_params
    params.require(:track_favorite).permit(:track_id)
  end
end
