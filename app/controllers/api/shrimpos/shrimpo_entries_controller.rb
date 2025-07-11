class Api::Shrimpos::ShrimpoEntriesController < ApplicationController
  def show
    entry = ::Shrimpo.friendly.find(params[:shrimpo_id]).shrimpo_entries.friendly.find(params[:id])
    render json: entry, current_user: current_user, include: ['shrimpo_votes', 'posts', 'trophy_awards', 'user', 'shrimpo_voting_category_scores']
  end

  def create
    shrimpo = Shrimpo.friendly.find params[:shrimpo_id]
    entry = shrimpo.shrimpo_entries.new shrimpo_entry_params
    entry.user = current_user

    if entry.save
      ActiveSupport::Notifications.instrument 'shrimpo.entry.created', title: entry.title, username: entry.user.username
      render json: entry
    else
      ActiveSupport::Notifications.instrument 'shrimpo.entry.create.error', title: entry.title, username: entry.user.username, errors: entry.errors, params: params
      render json: { errors: entry.errors }, status: 422
    end
  end

  private
  def shrimpo_entry_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :audio
    ])
  end
end
