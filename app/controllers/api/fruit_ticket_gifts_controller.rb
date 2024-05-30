class Api::FruitTicketGiftsController < ApplicationController
  before_action :current_radio_required

  def create
    fruit_ticket_transaction = FruitTicketTransaction.new fruit_ticket_gift_params
    fruit_ticket_transaction.from_user = current_user
    fruit_ticket_transaction.transaction_type = :user_gift
    fruit_ticket_transaction.transact_and_save!
    render json: fruit_ticket_transaction
  end

  private
  def fruit_ticket_gift_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :to_user_id, :amount])
  end
end
