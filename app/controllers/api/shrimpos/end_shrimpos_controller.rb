class Api::Shrimpos::EndShrimposController < ApplicationController
  def create
    # TODO auth
    shrimpo = Shrimpo.friendly.find params[:shrimpo_id]
    if !shrimpo.voting? && (!current_user != shrimpo.user || !current_user.admin?)
      render head: :forbidden
    end

    if shrimpo.tally_results!
      ActiveSupport::Notifications.instrument 'shrimpo.ended', title: shrimpo.title
      render json: shrimpo
    else
      ActiveSupport::Notifications.instrument 'shrimpo.ended.error', title: shrimpo.title, errors: shrimpo.errors, params: params
      render json: { errors: shrimpo.errors }, status: 422
    end
  end
end
