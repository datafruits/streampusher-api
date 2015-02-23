class ListensController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  def index
    @listens = Listen.group_by_day(:created_at).count
    render json: @listens
  end
end
