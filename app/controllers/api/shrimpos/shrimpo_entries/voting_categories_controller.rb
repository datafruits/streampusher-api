class Api::Shrimpos::ShrimpoEntries::VotingCategoriesController < ApplicationController
  def create
    authorize! :vote, :shrimpo
    shrimpo_entry = ShrimpoEntry.friendly.find params["shrimpo_entry_id"]
    shrimpo = shrimpo_entry.shrimpo
    ActiveRecord::Base.transaction do
      params[:data].each do |voting_category|
        category = shrimpo.shrimpo_voting_categories.find_by name: voting_category["attributes"]["category_name"]
        vote = ShrimpoVote.find_or_initialize_by shrimpo_entry_id: shrimpo_entry.id, user_id: current_user.id, shrimpo_voting_category: category
        vote.score = voting_category["attributes"]["score"]
        vote.save!
      end
    end
    render head: :ok
  end
end
