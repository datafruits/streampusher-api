class Api::ShrimposController < ApplicationController
  def index
    shrimpos = Shrimpo.all
    render json: shrimpos

  end

  def create
    shrimpo = Shrimpo.new shrimpo_params(:shrimpo_type)
    shrimpo.user = current_user
    # TODO allow user to select trophies
    # ["golden shrimpo", "silveren shrimpo", "bronzeen shrimpo", "good beverage"]
    shrimpo.gold_trophy = Trophy.find_by(name: "golden shrimpo")
    shrimpo.silver_trophy = Trophy.find_by(name: "silveren shrimpo")
    shrimpo.bronze_trophy = Trophy.find_by(name: "bronzeen shrimpo")
    shrimpo.consolation_trophy = Trophy.find_by(name: "good beverage")

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

  def update
    shrimpo = Shrimpo.friendly.find params[:id]
    unless current_user && (current_user == shrimpo.user || current_user.admin?)
      return head :forbidden
    end

    if shrimpo.update(shrimpo_params)
      render json: shrimpo, current_user: current_user
    else
      respond_with_errors(shrimpo)
    end
  end

  private
  def shrimpo_params(*extra_fields)
    attributes = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :start_at, :end_at, :rule_pack, :duration, :cover_art, :zip, :emoji, *extra_fields
    ])
    nested = params.dig(:data, :attributes)
    if nested.is_a?(ActionController::Parameters)
      categories = nested.permit(shrimpo_voting_categories: [:id, :name, :emoji],
                                 shrimpo_voting_categories_attributes: [:id, :name, :emoji])
      rows = categories[:shrimpo_voting_categories_attributes] || categories[:shrimpo_voting_categories]
      attributes[:shrimpo_voting_categories_attributes] = rows if rows
    end
    attributes
  end
end
