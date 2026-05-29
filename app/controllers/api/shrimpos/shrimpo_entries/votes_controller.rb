class Api::Shrimpos::ShrimpoEntries::VotesController < ApplicationController
  def create
    authorize! :vote, :shrimpo
    shrimpo_entry = ShrimpoEntry.friendly.find params[:shrimpo_entry_id]
    vote = ShrimpoVote.find_or_initialize_by shrimpo_entry_id: shrimpo_entry.id, user_id: current_user.id
    vote.attributes = shrimpo_vote_params
    if vote.save
      ActiveSupport::Notifications.instrument 'shrimpo.vote.created', title: shrimpo_entry.title, username: shrimpo_entry.user.username, score: vote.score
      render json: vote
    else
      ActiveSupport::Notifications.instrument 'shrimpo.vote.create.error', title: shrimpo_entry.title, username: shrimpo_entry.user.username, score: vote.score, errors: vote.errors, params: params
      render json: { errors: vote.errors }, status: 422
    end
  end

  private
  def shrimpo_vote_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :score
    ])
  end
end
