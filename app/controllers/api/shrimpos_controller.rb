class Api::ShrimposController < ApplicationController
  def index
    shrimpos = Shrimpo.all
    render json: shrimpos
  end

  def create
    shrimpo = Shrimpo.new shrimpo_params
    shrimpo.user = current_user
    if shrimpo.save_and_deposit_fruit_tickets!
      ActiveSupport::Notifications.instrument 'shrimpo.created', username: shrimpo.user.username, title: shrimpo.title
      render json: shrimpo
    else
      ActiveSupport::Notifications.instrument 'shrimpo.create.error', username: shrimpo.user.username, title: shrimpo.title, errors: shrimpo.errors, params: params
      render json: { errors: shrimpo.errors }, status: 422
    end
  end

  def show
    shrimpo = Shrimpo.friendly.find params[:id]
    render json: shrimpo, include: ['shrimpo_entries', 'posts']
  end

  private
  def shrimpo_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :start_at, :end_at, :rule_pack, :duration, :cover_art, :zip, :emoji
    ])
  end
end
