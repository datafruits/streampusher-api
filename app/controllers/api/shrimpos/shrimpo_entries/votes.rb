class Api::Shrimpos::ShrimpoEntries::VotesController < ApplicationController
  def create
    vote = ShrimpoVote.find_or_initialize_by shrimpo_entry_id: params[:shrimpo_entry_id], user_id: current_user.id
    if vote.save
      render json: vote
    else
      render json: { errors: entry.errors }, status: 422
    end
  end

  private
  def shrimpo_vote_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :score
    ])
  end
end
