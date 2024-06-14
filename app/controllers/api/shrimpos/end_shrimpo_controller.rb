class Api::Shrimpos::EndShrimpoController < ApplicationController
  def create
    shrimpo = Shrimpo.friendly.find params[:shrimpo_id]

    if shrimpo.tally_results!
      ActiveSupport::Notifications.instrument 'shrimpo.ended', title: shrimpo.title
      render json: shrimpo
    else
      ActiveSupport::Notifications.instrument 'shrimpo.ended.error', title: shrimpo.title, errors: shrimpo.errors, params: params
      render json: { errors: shrimpo.errors }, status: 422
    end
  end
end
