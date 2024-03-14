class Api::Shrimpos::ShrimpoEntries::VotesController < ApplicationController
  def create
    shrimpo_entry = ShrimpoEntry.friendly.find params[:shrimpo_entry_id]
    vote = ShrimpoVote.find_or_initialize_by shrimpo_entry_id: shrimpo_entry.id, user_id: current_user.id
    vote.attributes = shrimpo_vote_params
    if vote.save
      render json: vote
    else
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
