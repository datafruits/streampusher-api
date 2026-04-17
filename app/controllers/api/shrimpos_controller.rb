class Api::ShrimposController < ApplicationController
  def index
    shrimpos = Shrimpo.all
    render json: shrimpos

  end

  def create
    shrimpo = Shrimpo.new shrimpo_params
    shrimpo.user = current_user
    # TODO allow user to select trophies
    # ["golden shrimpo", "silveren shrimpo", "bronzeen shrimpo", "good beverage"]
    shrimpo.gold_trophy = Trophy.find_by(name: "golden shrimpo")
    shrimpo.silver_trophy = Trophy.find_by(name: "silveren shrimpo")
    shrimpo.bronze_trophy = Trophy.find_by(name: "bronzeen shrimpo")
    shrimpo.consolation_trophy = Trophy.find_by(name: "good beverage")

    if shrimpo.mega? && shrimpo_voting_categories_params
      shrimpo_voting_categories_params.each do |category|
        shrimpo.shrimpo_voting_categories.build name: category, emoji: ":#{category}:"
      end
    end

    if shrimpo.valid? && shrimpo.save_and_deposit_fruit_tickets!
      ActiveSupport::Notifications.instrument 'shrimpo.created', username: shrimpo.user.username, title: shrimpo.title
      render json: shrimpo
    else
      ActiveSupport::Notifications.instrument 'shrimpo.create.error', username: shrimpo.user.username, title: shrimpo.title, errors: shrimpo.errors, params: params
      errors = shrimpo.errors.map do |error|
        {
          status: "422",
          source: { pointer: "/data/attributes/#{error.attribute}" },
          title: "Invalid Attribute",
          detail: error.full_message
        }
      end
      render json: { errors: errors }, status: 422
    end
  end

  def show
    shrimpo = Shrimpo.friendly.find params[:id]
    render json: shrimpo, serializer: ShrimpoSerializer, current_user: current_user, include: ['shrimpo_entries', 'posts', 'shrimpo_entries.trophy_awards', 'shrimpo_voting_categories', 'shrimpo_voting_categories.shrimpo_voting_category_scores']
  end

  private
  def shrimpo_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :start_at, :end_at, :rule_pack, :duration, :cover_art, :zip, :emoji
    ])
  end

  def shrimpo_voting_categories_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :shrimpo_voting_categories
    ])
  end
end
